#!/usr/bin/env casperjs --ignore-ssl-errors=yes
#
# Convert UoN module code to crsid (for use in URLs)
#
# Copyright (C) 2013 Richard Mortier <mort@cantab.net>. All Rights Reserved.
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

require './jquery-2.0.3.min.js'
system = require 'system'
{thisyear, lastyear, dates} = require './uonvars.coffee'

casper = require('casper').create({
  clientScripts:  [
    './jquery-2.0.3.min.js',
    ],

  logLevel: "debug",
  verbose: false,

  viewportSize: { width: 1280, height: 640 },
  pageSettings: {
    loadImages:  false,
    loadPlugins: false,
  }
})

## error handling
# casper.on 'page.error', (msg,ts) -> page_error msg, ts
# casper.on 'load.error', (msg,ts) -> page_error msg, ts
# casper.on 'remote.alert', (msg) -> remote_alert msg
# casper.on 'remote.message', (msg) -> remote_message msg

## debugging
# casper.on 'step.added', (r) -> console.log "step.added", r
# casper.on 'step.complete', (r) -> console.log "step.complete", r
# casper.on 'step.created', (r) -> console.log "step.create", r

## handle options
usage = ->
  casper.die "Usage: #{ system.args[3] } [--year=<#{thisyear}] <modulecodes...>", 1

casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

yr = casper.cli.get('year')
year = if yr? then dates[yr] else dates[thisyear]
codes = casper.cli.args

search_url =
  "http://modulecatalogue.nottingham.ac.uk/Nottingham/asp/main_search.asp"

## have to start before we can stack `then` handlers
casper.start -> dbg "starting!"

## stack a `then` handler for each course of interest
crsids = {}
casper.then ->
  $(codes).each (i, code) ->
    casper.then -> casper.open search_url
    casper.then ->
      code = code.toUpperCase()
      @evaluate ((year, code) ->

        $('input#year_id').val(year)
        $('input#mnem').val(code)
        $('input#cmdMnem').click()

      ), { year, code }

    casper.then ->
      crsid = @evaluate ->
        ms = /[\\?&]crs_id=([^&#]*)/.exec($(location).attr('href'))
        ms?[1]
      if crsid? then crsids[code] = crsid

casper.run ->
  @echo JSON.stringify crsids
  @exit()
