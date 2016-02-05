#!/usr/bin/env casperjs --ignore-ssl-errors=true

# Copyright (c) 2016, Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

require './jquery-2.0.3.min.js'
system = require 'system'
fs = require 'fs'
utils = require 'utils'

casper = require('casper').create({
  clientScripts:  [
    './jquery-2.0.3.min.js'
  ],

  logLevel: "error",
  verbose: "false",

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

## handle inputs

usage = -> casper.die "Usage: #{ system.args[3] } <inputs>", 1
infile = casper.cli.args[0]
usage() if not infile?
inputs = fs.open(infile, "r").read()
usage() if not inputs?

## go!
casper.start -> ""
casper.each ([line, idx] for line,idx in inputs.split("\n") when line isnt ''),
  (self, [line, idx]) ->
    uri = line.split("#")[0]
    @wait 50, () ->
      @thenOpen uri, () ->
        # @capture "kickstarter-#{idx}.png"
        rs = @evaluate ((uri, idx) ->
          currency = $("span.money").attr("class")
          # console.log currency
          {
            idx: idx,
            uri: uri,
            currency: currency
          }
        ) , { uri, idx }

        # XXX assume first 3 letter string is the currency code
        currency = (s for s in rs.currency.split(" ") when s.length == 3)[0]
        @echo "#{rs.idx}, #{currency}, #{rs.uri}"

casper.run ->
  @exit()
