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

  logLevel: "error",
  verbose: "false",

  viewportSize: { width: 1280, height: 640 },
  pageSettings: {
    loadImages: false,
    loadPlugins: false
  },

  userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
})

## lib imports
{dbg, remotelog} = require './libmort.coffee'

## error handling, debugging
# casper.on 'remote.alert', (msg) -> remotelog "alert", msg
# casper.on 'remote.message', (msg) -> remotelog "msg", msg

# casper.on 'page.resource.received', (response) ->
#   dbg response.status
# switch(error.substring(0, 1)){
#        case '4'

## handle options

usage = -> casper.die "Usage: #{ system.args[3] } <author> <title>", 1
[author, title] = casper.cli.args
usage() if not (author? and title?)

author = encodeURIComponent(author)
title = encodeURIComponent(title)

## setup uris and scrapers

goog_base_uri = "http://scholar.google.co.uk/scholar"
goog_query = "as_q=#{title}&as_occt=title&as_sauthors=#{author}"
goog_uri = "#{goog_base_uri}?#{goog_query}"

goog_scrape = (author) ->
  entry = $("#gs_ccl > .gs_r").eq(0).contents(".gs_ri")
  title = $(entry).contents("h3.gs_rt").text()
  cites = $(entry).contents(".gs_fl").text().match("Cited by ([0-9]+)")[1]
  {
    title: $.trim(title)
    cites: $.trim(cites)
    authors: ""
    venue: ""
  }

msft_base_uri = "http://academic.research.microsoft.com/Search"
msft_query = "query=author%3a%28#{author}%29%20#{title}"
msft_uri = "#{msft_base_uri}?#{msft_query}"

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
    authors: $.trim(authors)
    venue: $.trim(venue)
  }

sites = [
  ["MSFT", msft_uri, msft_scrape],
  ["GOOG", goog_uri, goog_scrape],
  ]

## go!
casper.start -> dbg "starting!"
casper.then ->
  @each sites, (self, site) ->
    [ svc, uri, scrapefn ] = site
    @thenOpen uri, () ->
      rs = @evaluate scrapefn, { author }
      @echo "#{author} | '#{title}' | #{svc} | '#{uri}' |
        '#{rs.title}' | '#{rs.authors}' | #{rs.cites} | '#{rs.venue}'"

casper.run ->
  casper.exit()
