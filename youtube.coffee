#!/usr/bin/env casperjs

# Copyright (c) 2014, Richard Mortier <mort@cantab.net>
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
# casper.on 'remote.alert', (msg) -> remotelog "alert", msg
# casper.on 'remote.message', (msg) -> remotelog "msg", msg
# casper.on 'remote.error', (msg) -> remotelog "error", msg

## handle inputs

usage = -> casper.die "Usage: #{ system.args[3] } <inputs>", 1
infile = casper.cli.args[0]
usage() if not infile?
inputs = fs.open(infile, "r").read()
usage() if not inputs?

stats = {
  views: 0,
  videos: 0,
  likes: 0,
  dislikes: 0
  }

## go!
casper.start -> ""
casper.echo '{ "videos": ['
casper.each ([uri, idx] for uri,idx in inputs.split("\n") when uri isnt ''),
  (self, [uri, idx]) ->
    @wait 500, () ->
      @thenOpen uri, () ->
        # @capture "youtube.png"
        rs = @evaluate ((uri, idx) ->
          published = $("#watch-uploader-info").text().match("Published on (.*)")
          published = if published?.length > 0 then published[1]
          title = $("h1#watch-headline-title").text().trim()
          views = $(".watch-view-count").text().trim()

          vote_tag = (vote) ->
            "span#watch-like-dislike-buttons button#watch-#{vote} span.yt-uix-button-content"
          likes = $(vote_tag "like").text().trim()
          dislikes = $(vote_tag "dislike").text().trim()
          {
            idx: idx,
            uri: uri,
            published: published,
            title: title,
            views: parseInt(views.replace(/,/g,'')),
            likes: parseInt(likes.replace(/,/g,'')),
            dislikes: parseInt(dislikes.replace(/,/g,''))
          }
        ) , { uri, idx }

        stats.videos += 1
        stats.views += rs.views
        stats.likes += rs.likes
        stats.dislikes += rs.dislikes

        @echo "#{if idx!=0 then ',' else ''}#{JSON.stringify rs}"

casper.run ->
  @echo "], \"stats\": #{JSON.stringify stats}}"
  @exit()
