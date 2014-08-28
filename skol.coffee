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

  viewportSize: { width: 1280, height: 640 },
  pageSettings: {
    loadImages:  false,
    loadPlugins: false
  },

  userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
})

## error handling, debugging

colorizer = require('colorizer').create('Colorizer')

casper.on 'remote.alert', (msg) ->
  @log colorizer.colorize "[remote-alert] #{msg}", "WARN_BAR"

casper.on 'remote.message', (msg) ->
  @log colorizer.colorize "[remote] #{msg}", "WARN_BAR"

# casper.on 'page.error', (msg,ts) ->
#   ## format remote page error per casperjs standard; based on casperjs code
#   console.error colorizer.colorize "[remote] #{msg}", 'RED_BAR', 80
#   for t in ts
#     do (t) ->
#       m = fs.absolute t.file + ":" + c.colorize t.line, "COMMENT"
#       if t['function']
#         m += " in " + c.colorize t['function'], "PARAMETER"
#       console.error "  #{ m }"

## debug logging
dbg = (m) ->
  casper.log colorizer.colorize "[debug] #{m}", "INFO_BAR"

usage = ->
  casper.die "Usage: #{ system.args[3] } <author> <title>", 1

## handle options
casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

## setup uri
author = encodeURIComponent(casper.cli.args[0])
title = encodeURIComponent(casper.cli.args[1])
usage() if (author == "" or title == "")

goog_base_uri = "http://scholar.google.co.uk/scholar"
goog_query = "as_q=#{title}&as_occt=title&as_sauthors=#{author}"
goog_uri = "#{goog_base_uri}?#{goog_query}"

goog_scrape = (author) ->
  entry = $("#gs_ccl > .gs_r").eq(0).contents(".gs_ri")
  title = $(entry).contents("h3.gs_rt").text()
  cites = $(entry).contents(".gs_fl").text().match("Cited by ([0-9]+)")[1]
  return { title: title, cites: cites, authors: author }

msft_base_uri = "http://academic.research.microsoft.com/Search"
msft_query = "query=author%3a%28#{author}%29%20#{title}"
msft_uri = "#{msft_base_uri}?#{msft_query}"

msft_scrape = (author) ->
  entry = $("li.paper-item").contents()
  console.log $("li.paper-item").html()
  title = "TITLE"
  cites = 0
  authors = "AUTHORS"
  return { title: title, cites: cites, authors: author }

sites = [
  ["GOOG", goog_uri, goog_scrape],
  ["MSFT", msft_uri, msft_scrape]
  ]

## go!
casper.start -> dbg "starting!"
casper.then ->
  @each sites, (self, site) ->
    [ svc, uri, scrape_fn ] = site
    @thenOpen uri, () ->
      result = @evaluate scrape_fn, { author }
      @echo "#{svc}, '#{result.title}', '#{result.authors}', #{result.cites}, '#{uri}'"

casper.run ->
  casper.exit()
