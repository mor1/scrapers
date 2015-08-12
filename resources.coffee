#!/usr/bin/env casperjs --ignore-ssl-errors=true --web-security=no --ssl-protocol=tlsv1
#
# Copyright (c) 2015, Richard Mortier <mort@cantab.net>
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

system = require 'system'
fs = require 'fs'

{dbg, remotelog} = require './libmort.coffee'

## setup casper instance
casper = require('casper').create({
  clientScripts:  [],

  logLevel: "error",
  verbose: "false",

  viewportSize: { width: 1024, height: 768 },
  pageSettings: {
    loadImages: true,
    loadPlugins: true
  },

  userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
})

## setup inputs
usage = -> casper.die "Usage: #{ system.args[3] } <inputsfile or URL>", 1
infile = casper.cli.args[0]
usage() if not infile?

urls = if fs.isReadable(infile)
    inputs = fs.open(infile, "r").read()
    ([uri, idx] for uri,idx in inputs.split("\n") when uri isnt '')
  else
    ([uri, idx] for uri,idx in infile.split("\n") when uri isnt '')

## setup casper object to start and iterate over inputs, saving each output
pages = {}

casper.start -> ""

casper.each urls,
  (self, [uri, idx]) ->
    @then () ->
      resources = []
      @page.open uri
      @page.onResourceRequested = (rd, req) -> resources.push(decodeURI(rd.url))
      @wait 4000, () ->
        pages[uri] = resources

## entry point
casper.run ->
  @echo JSON.stringify(pages)
  @exit()
