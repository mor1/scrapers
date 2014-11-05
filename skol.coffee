#!/usr/bin/env casperjs

# Copyright (C) 2012 Richard Mortier <mort@cantab.net>. All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA.

system = require 'system'
fs = require 'fs'
utils = require 'utils'

casper = require('casper').create({
  clientScripts:  [
    './jquery-2.0.3.min.js'
  ],

  logLevel: "debug",
  verbose: "true",

  viewportSize: { width: 800, height: 600 },
  pageSettings: {
    loadImages: true,
    loadPlugins: true
  },

  userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
})

## lib imports
{dbg, remotelog} = require './libmort.coffee'

## error handling, debugging
casper.on 'remote.alert', (msg) -> remotelog "alert", msg
casper.on 'remote.message', (msg) -> remotelog "msg", msg
casper.on 'remote.error', (msg) -> remotelog "error", msg

casper.on 'page.resource.received', (response) ->
  dbg "#{response.status}, #{response.url}"
#   switch response.status
#     when 503
#       # @capture "captcha.png"
#       fs.write "captcha.html", @getHTML()
#       # captcha = raw_input "captcha> "
#       # @log "CAPTCHA: #{captcha}"
#       # @fill "form[action='CaptchaRedirect']", { 'captcha': captcha }, true

raw_input = (prompt) ->
  system.stdout.write "#{prompt}"
  system.stdin.readLine()

goog_scrape = (author) ->
  entry = $("#gs_ccl > .gs_r").eq(0).contents(".gs_ri")
  if $(entry).length == 0
    {
      title: 'undefined'
      cites: 'undefined'
      wos: 'undefined'
      authors: 'undefined'
      venue: 'undefined'
    }
  else
    title = $(entry).contents("h3.gs_rt").text()
    console.log "TITLE:'#{title}'"

    cites = $(entry).contents(".gs_fl").text().match("Cited by ([0-9]+)")
    console.log "XXXXX #{cites}"
    cites = if cites.length > 0 then cites[1]
    console.log "CITES:'#{cites}'"

    wos = $(entry).contents(".gs_fl").text().match("Web of Science: ([0-9]+)")
    wos = if wos? then wos[1]
    console.log "WOS:'#{wos}'"
    rv = {
      title: $.trim(title)
      cites: $.trim(cites)
      wos: $.trim(wos)
      authors: ""
      venue: ""
    }
    console.log "RV.TITLE:'#{rv.title}'"
    rv

msft_scrape = (author) ->
  entry = $("li.paper-item").eq(0)
  title = $(entry).find("a#ctl00_MainContent_PaperList_ctl01_Title").text()
  cites = $(entry)
    .find("a#ctl00_MainContent_PaperList_ctl01_Citation")
    .text()
    .replace(/Citations: /g, '')
  authors = $(entry).find(".content").text()
  venue = $(entry).find(".conference").text().replace(/\n/g, '')
  {
    title: $.trim(title)
    cites: $.trim(cites)
    wos: ''
    authors: $.trim(authors)
    venue: $.trim(venue)
  }

scrape = (outfile, errfile, author_raw, author, title_raw, title, oid) ->

  goog_base_uri = "http://scholar.google.co.uk/scholar"
  goog_query = "as_q=#{title}&as_occt=title&as_sauthors=#{author}"
  goog_uri = "#{goog_base_uri}?#{goog_query}"

  msft_base_uri = "http://academic.research.microsoft.com/Search"
  msft_query = "query=author%3a%28#{author}%29%20#{title}"
  msft_uri = "#{msft_base_uri}?#{msft_query}"

  sites = [
    # ["MSFT", msft_uri, msft_scrape],
    ["GOOG", goog_uri, goog_scrape],
    ]

  casper.then ->
    @each sites, (self, site) ->
      [ svc, uri, scrapefn ] = site
      dbg "URI:'#{uri}'"
      @thenOpen uri, () ->
        @capture "page.png"
        rs = @evaluate scrapefn, { author }
        dbg "RS:'#{JSON.stringify(rs)}'"
        try
          os = "#{oid}\t#{author}\t#{rs.title}\t#{svc}\t#{rs.wos}\t#{rs.cites}"
          # os +=
          # "#{author_raw}\t#{title_raw}\t#{uri}\t#{rs.venue}\t#{rs.citation}"
          os += "\n"
          fs.write outfile, os, "a"
        catch error
          @log "ERROR: '#{error}'"
          fs.write errfile,
            "#{author_raw} | #{title_raw} | #{uri} | #{error}\n", "a"
          @capture "captcha-pre.png"
          @waitForSelector 'img#recaptcha_challenge_image',
            ( ->
              @capture "captcha-post.png"
              captcha = raw_input "captcha> "
              @log "CAPTCHA: #{captcha}"
              @fill "form[method='get']",
                { 'recaptcha_response_field': captcha }, true
              ),
              ->,
              10000


## handle inputs

usage = -> casper.die "Usage: #{ system.args[3] } <inputs>", 1
infile = casper.cli.args[0]
inputs = fs.open(infile, "r").read()
usage() if not inputs?

## go!

casper.start -> dbg "starting!"

outfile = "#{infile}.out"
try fs.remove outfile catch error

errfile = "#{infile}.err"
try fs.remove errfile catch error

stopwords = (ws) ->
  (w for w in ws.join(" ").split(" ") when w.toLowerCase() not in [
    "and", "for", "of", "a", "the"
    ])

casper.each (i for i in inputs.split("\n") when i isnt ''), (self, input) ->
  @wait 1000, () ->
    [oid, author_raw, title_raw...] = input.split("\t")
    surname = author_raw.trim().replace(/[,.:]/g,'').split(' ')[0]
    author = encodeURIComponent("#{surname}")

    words = stopwords(title_raw).join(" ").replace(/[,.:]/g,'').trim()
    dbg words
    title = encodeURIComponent(words)
    scrape outfile, errfile, author_raw, author, title_raw, title, oid

casper.run -> casper.exit()
