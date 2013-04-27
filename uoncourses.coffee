#!/usr/bin/env casperjs --ignore-ssl-errors=yes
#
# Scrape UoN timetable data and module details given module codes.
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

require './jquery-1.9.1.min.js'
system = require 'system'
fs = require 'fs'
utils = require 'utils'

{modules, dates, courses} = require './uonvars.coffee'
{page_error, remote_alert, remote_message, dbg, lpad, rpad} =
  require './libmort.coffee'

casper = require('casper').create({
  clientScripts:  [
    './jquery-1.9.1.min.js'
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
casper.on 'page.error', (msg,ts) -> page_error msg, ts
casper.on 'load.error', (msg,ts) -> page_error msg, ts
casper.on 'remote.alert', (msg) -> remote_alert msg
casper.on 'remote.message', (msg) -> remote_message msg

## debugging
# casper.on 'step.added', (r) -> console.log "step.added", r
# casper.on 'step.complete', (r) -> console.log "step.complete", r
# casper.on 'step.created', (r) -> console.log "step.create", r

## handle options
usage = ->
  casper.die "Usage: #{ system.args[3] } --year=<year> [course-ids...]", 1

casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

year = casper.cli.get('year')
username = casper.cli.get('username')
password = casper.cli.get('password')
crs_ids = casper.cli.args

## the url you first thought of makes extensive use of frames...
## saturn_login = "https://saturnweb.nottingham.ac.uk/Nottingham/default.asp"

## the url you next thought of is actually unnecessary -- programme spec URLs
## are not protected by the SATURN login. wtf.
# 
# saturn_login = "https://saturnweb.nottingham.ac.uk/Nottingham/asp/user_logon.asp"
# casper.start saturn_login, ->

#   ## unfortunately a webkit bug (possibly being too keen in applying the
#   ## standards) means that it inserts the closing </form> tag immediately so
#   ## as not to include the table rows inside the form, meaning @fill fails.
#   ## complete the form by hand in an eval instead.
#   # 
#   # @fill 'form1', {
#   #   "UserName": username,
#   #   "Password": password
#   #   }, false

#   @evaluate ((username, password) ->
#     $('input[name="UserName"]').val(username);
#     $('input[name="Password"]').val(password);
#     $('input#SUBMIT1').click();
#   ), {username, password}

saturn_spec_url = (yr, id) ->
  saturn_spec_base = "http://programmespec.nottingham.ac.uk/nottingham/asp/view_specification.asp"
  saturn_spec_params = (yr, id) -> "year_id=#{dates[yr]}&crs_id=#{courses[id]}"
  "#{saturn_spec_base}?#{saturn_spec_params yr, id}"

## have to start before we can stack `then` handlers
casper.start -> dbg "starting!"

## stack a `then` handler for each course of interest
specs = []
casper.then ->
  $(crs_ids).each (i, crs_id) ->
    url = "#{saturn_spec_url(year, crs_id)}"
    casper.then -> casper.open url
    casper.then ->
      spec = @evaluate ((modules, dates, year) ->
        
        module_url = (yr, id) ->
          if (modules[id])? 
            module_base = "http://modulecatalogue.nottingham.ac.uk/Nottingham/asp/moduledetails.asp"
            module_params = (yr, id) -> "year_id=#{dates[yr]}&crs_id=#{modules[id]}"
            "#{module_base}?#{module_params yr, id}"
          else
            null

        spec = { "url": $(location).attr('href') }
        
        ## helper functions to walk stupid table-formatted data
        key = (sel, rows) ->
          $("td:contains(#{sel})", rows).parent("tr").first()
        colsof = (i, key) ->
          $("td table tbody tr td", $(key).nextAll().eq(i))
        rowsof = (i, key) ->
          $("td table tbody tr", $(key).nextAll().eq(i))
        partsof = (key) ->
          $("td table tbody", $(key).nextAll().eq(0))
        textof = (i, key) -> colsof(i, key).first().text()
        textofall = (i, key) ->
          colsof(i, key).map((i, v) -> $(v).html()).toArray().join("|")

        ## first, the simple metadata
        rows = $("tbody tr")
        spec['title'] = textof 1, key "1 Title", rows
        spec['code'] = textof 1, key "2 Course code", rows
        spec['type'] = textof 1, key "4 Type of course", rows
        spec['mode'] = textof 1, key "5 Mode of delivery", rows
        spec['aims'] = textofall 1, key "Educational Aims", rows

        ## next, course modules
        mods = (t, part) ->
          retval = []
          rows = $("td:contains(#{t})", $(part)).parent("tr").nextAll()
          table = $("td table", rows).first()
          $("tr", table).slice(1,-1).each (i, m) ->
            [code, title, credits, comp, taught] =
              $("td", m).map((i, v) -> $(v).text()).toArray()

            retval.push({
              'code': code, 'title': title, 'credits': credits,
              'comp': comp, 'taught': taught, 'url': module_url year, code
              })
          retval

        partof = (parts, sel) ->
          part = $("td:contains(#{sel})", parts).parent("tr").nextAll()
          retval = {}
          retval['o'] = mods "Restricted", part
          retval['c'] = mods "Compulsory", part
          retval
        
        parts = partsof key "2 Course Structure", rows

        spec['modules'] = {}
        spec['modules']['part_q'] = partof parts, "Qualifying Year"
        spec['modules']['part_i'] = partof parts, "Part I"        
        spec['modules']['part_ii'] = partof parts, "Part II"
        spec['modules']['part_iii'] = partof parts, "Part III"
        
        spec
      ), { modules, dates, year }
      specs.push spec

casper.run ->
  @echo JSON.stringify specs
  @exit()
