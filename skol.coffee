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

## setup page callbacks
# 
page.viewportSize = { width: 1280, height: 640 }

page.onError = (msg, trace) ->
  console.log "# ERR:", msg
  for t in trace
    do (t) ->
      console.log "#     ",
        t.file + "[" + t.line + "]: " + (t.function? " (f: #{ t.function })")
  phantom.exit()

page.onConsoleMessage = (msg) ->
  console.log msg

page.onAlert = (msg) ->
  console.log "@", msg

page.onLoadFinished = (status) ->
  console.log "* fetched page, status=", status
  if status isnt 'success'
    console.log '# unable to grab page!', success
  else main page
  phantom.exit()

page.save = (path) ->
  fs.write path, page.content, "w"

## main logic
# 
jqurl = './jquery-1.8.2.min.js'
jquery = (page) ->
  console.log "* injecting jquery"
  if !(page.injectJs jqurl)
    console.log "# injection failed!"
    phantom.exit()
    
  console.log "* injected"
  # page.includeJs "file://./#{ jqurl }", (process page)

process = (page) ->
  console.log "* processing"
  page.save "debug.2.html"

  page.evaluate ->
    entry = $("#gs_ccl > .gs_r").eq(0).contents(".gs_ri")
    # console.log $(entry).html()
    title = $(entry).contents("h3.gs_rt").text()
    cites = $(entry).contents(".gs_fl").text().match("Cited by ([0-9]+)")[1]
    console.log "Title: '#{ title }', Cites: #{ cites }"
    
main = (page) ->
  console.log "* success"
  page.render "debug.1.png"
  jquery page
  process page

## main
# 
if system.args.length < 3
  console.log "Usage: skol.coffee <author> <title>"
  phantom.exit()

author = """author:"#{ system.args[1] }" """
console.log "* author: ", author

title = """ "#{ system.args[2] }" """
console.log "* title: ", title

uri = encodeURI('http://scholar.google.co.uk/scholar?q=' + author + title)
console.log "* uri: ", uri

console.log "* opening page"
page.open uri
