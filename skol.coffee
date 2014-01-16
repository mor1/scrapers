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
    './jquery-1.8.2.min.js'
  ],

  logLevel: "debug",
  verbose: false,
  viewportSize: { width: 1280, height: 640 },

  pageSettings: {
    loadImages:  false,
    loadPlugins: false,
    userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
  }
})

usage = ->
  casper.die "Usage: #{ system.args[3] } <author> <title>", 1

## handle options
casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

## setup uri
author = encodeURI(casper.cli.args[0])
title = encodeURI(casper.cli.args[1])
usage() if (author == "" or title == "")
uri = encodeURI("http://scholar.google.co.uk/scholar?q=#{title}+#{author}")

## go!
casper.start uri, ->
  @echo JSON.stringify @evaluate ((author) ->
    entry = $("#gs_ccl > .gs_r").eq(0).contents(".gs_ri")
    title = $(entry).contents("h3.gs_rt").text()
    cites = $(entry).contents(".gs_fl").text().match("Cited by ([0-9]+)")[1]
    return { title: title, cites: cites, author: author }
    ), { author }

casper.run ->
  casper.exit()
