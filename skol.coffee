#!/usr/bin/env phantomjs

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

## module imports
# 
page = require('webpage').create()
system = require 'system'
fs = require 'fs'

## file imports
#
jqurl = './jquery-1.8.2.min.js'
phantom.injectJs jqurl

logurl = './ba-debug.min.js'
phantom.injectJs logurl
debug.setLevel(3)
    
## setup page callbacks
# 
page.viewportSize = { width: 1280, height: 640 }

page.onError = (msg, trace) ->
  debug.error "# ERR:", msg
  for t in trace
    do (t) ->
      debug.error "#     ",
        t.file + "[" + t.line + "]: " + (t.function? " (f: #{ t.function })")
  phantom.exit()

page.onConsoleMessage = (msg) ->
  console.log msg

page.onAlert = (msg) ->
  debug.warn "@", msg

page.onLoadFinished = (status) ->
  debug.debug "* fetched page, status=", status
  if status isnt 'success'
    debug.error '# unable to grab page!', success
  else process page
  phantom.exit()

page.save = (path) ->
  fs.write path, page.content, "w"

## main logic
# 

process = (page) ->
  debug.debug "* success"
  page.render "debug.1.png"
  page.save "debug.2.html"

  # inject libraries into page
  debug.debug "* injecting jquery"
  if !(page.injectJs jqurl)
    debug.error "# injection failed!"
    phantom.exit()

  # now evaluate and process page contents
  debug.debug "* processing"
  page.evaluate ->
    entry = $("#gs_ccl > .gs_r").eq(0).contents(".gs_ri")
    title = $(entry).contents("h3.gs_rt").text()
    cites = $(entry).contents(".gs_fl").text().match("Cited by ([0-9]+)")[1]
    console.log "Title:'#{ title }', Cites:#{ cites }"

if system.args.length < 3
  console.error "Usage: skol.coffee <author> <title>"
  phantom.exit()

# don't add "author:" because then scholar screws up
author = """ "#{ system.args[1] }" """
debug.debug "* author: ", author

# don't add "title:" because then scholar screws up
title = """ #{ system.args[2] } """
debug.debug "* title: ", title

# title first because author is quoted
uri = encodeURI('http://scholar.google.co.uk/scholar?q=' + title + author)
debug.info "* uri: ", uri

debug.debug "* opening page"
page.open uri
