#!/usr/bin/env casperjs
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
cc = require('colorizer').create('Colorizer')

{modules, dates, current_year} = require './uonvars.coffee'
{page_error, remote_alert, remote_message, dbg, lpad, rpad} =
  require './libmort.coffee'

casper = require('casper').create({
  clientScripts:  [
    './jquery-1.9.1.min.js'
  ],

  logLevel: "warning",
  verbose: true,
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
  n = system.args[3]
  casper.die """
  Usage: #{n} [--json] [--all] [--details] [--year=<year:#{current_year}>] <modulecode>
  """, 1

casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

year = casper.cli.get('year')
year = if year of dates then dates[year] else dates[current_year]
## oh if only things were so simple. let's special case the world.
#
# port = if year == dates[current_year] then 8003 else 8004

port = switch current_year
  when '2013/14' then 8004
  when '2012/13' then 8003
  else casper.die "only 2013/14 and 2012/12 are supported"

do_json = casper.cli.options['json']
do_details = casper.cli.options['details']
do_all = casper.cli.options['all']

## setup uri
ms = if not do_all then casper.cli.args else Object.keys(modules)
uris = ms.map ((m,i) ->
  u = "http://uiwwwsci01.ad.nottingham.ac.uk:#{port}/reporting/Spreadsheet;module;id"
  p = "template=SWSCUST+Module+Spreadsheet&weeks=1-52"
  "#{u};#{modules[m.toUpperCase()]}?#{p}"
  )

murl = (y, c) ->
  u = "http://modulecatalogue.nottingham.ac.uk/Nottingham/asp/moduledetails.asp"
  p = "year_id=#{y}&crs_id=#{modules[c]}"
  "#{u}?#{p}"

tts = []
casper.start -> @echo "starting!", "debug"
casper.then ->
  $(uris).each (i, uri) ->
    ## fetch and parse timetable page
    casper.then -> casper.open uri
    casper.then ->
      tt = @evaluate (() ->
        tt = {}
        $("body > table").each (i,table) ->
          switch i % 4
            when 0
              if i != 0 then break

              title = $("table table b", table).first().text().split(/\s+/)
              tt['code'] = title[1]
              tt['title'] = title[2..].join(" ")
              tt['activities'] = []

            when 1
              activities_seen = []
              rows = $("tr", this).slice(1)
              rows.each (i,row) ->
                cells = $("td", this)
                code = $(cells[0]).text()
                if $.inArray(code, activities_seen) < 0
                  activity = {
                    'code': code,
                    'type': $(cells[1]).text(),
                    'size': $(cells[2]).text(),
                    'day': $(cells[4]).text(),
                    'start': $(cells[5]).text(),
                    'end': $(cells[6]).text(),
                    'room': $(cells[8]).text(),
                    'weeks': $(cells[12]).text()
                  }
                  tt['activities'].push activity
                  activities_seen.push code

        tt
      )

      tt['url'] = murl year, tt['code']

      ## intermittently get a spurious footer, which will mean we already
      ## added the real tt so don't add the blank one just created
      if tt['title'] != '' then tts.push tt

if do_details
  casper.then ->
    _tts = tts
    tts = []
    $(_tts).each (i, tt) ->
      url = murl year, tt['code']
      casper.then ->
        casper.open url

      casper.then ->
        tt = @evaluate ((tt, i) ->
          year = $("h3").text().replace(/Year\s+/, '')
          tt['year'] = year

          ps = $('p > b').each (i,p) ->
            label = $(p).text().replace(/:\s*$/, '')
            value = $(p).parents().first().text()
              .replace(label, '').replace(/\u00a0/g,'').replace(/\u2019/g,"'")
              .replace(/\n/g,'')
              .replace(/^:[\s\n]+/, '').replace(/[\s\n]+$/, '')

            switch label
              when 'Total Credits'
                tt['credits'] = value.replace(/:/g,'')*1
              when 'Level' then tt['level'] = value.split(/\s+/)[1]
              when 'Target Students'
                tt['target'] = value
              when 'Taught Semesters' then 0
              when 'Prerequisites'
                table = $(p).parents().first().next().next()
                values = $.map $("tbody > tr > td > a", table), (v,i) ->
                  $(v).html()
                tt['prereqs'] = values
              when 'Corequisites'
                table = $(p).parents().first().next().next()
                values = $.map $("tbody > tr > td > a", table), (v,i) ->
                  $(v).html()
                tt['coreqs'] = values
              when 'Summary of Content' then tt['summary'] = value
              when 'Method and Frequency of Class' then 0
              when 'Method of Assessment' then 0
              when 'Convenor'
                convenors = $(p).parents().first().html()
                  .split("<br>")[1..].map((x) -> x.trim())
                  .filter((x) -> x.length > 0)
                tt['convenors'] = convenors
              when 'Education Aims' then tt['aims'] = value
              when 'Learning Outcomes' then tt['outcomes'] = value
              when 'Offering School' then tt['school'] = value
              # else console.log "L '"+label+"' value '"+value+"'"
          tt
        ), { tt, i }
        tts.push tt

casper.run ->
  if do_json ## raw JSON dump
    @echo JSON.stringify {
      tool: """
      <a href="https://github.com/mor1/scrapers/blob/master/uontt.coffee">
        uontt.coffee
      </a>
      """,
      date: (new Date()).toString(),
      modules: tts,
    }

  else ## pretty print for human consumption
    format_weeks = (weeks) ->
      ## attempt to format the "weeks" column reasonably.
      ranges = weeks
        .split(/,/)
        .map((x) -> x.split(/[-] w[/]c |[-]/).map((x) -> x.trim()))

      retval = ''
      for range, i in ranges
        if i > 0 then retval += lpad('', 67)
        switch range.length
          when 2
            retval += "#{range[0]} (#{range[1]}),\n"
          when 4
            retval += "#{range[0]}--#{range[2]} (#{range[1]}--#{range[3]}),\n"
      retval.replace(/,\n$/,'')

    days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
      'Saturday', 'Sunday'
    ]

    $(tts).sort().each (i, m) =>
      @echo cc.format "#{m['code']} -- #{m['title']}", { fg: "white", bold: true }
      $(m['activities']).sort((x, y) ->
        ## order activities by day of week
        d = days.indexOf(x['day']) - days.indexOf(y['day'])
        if d < 0 then -1 else if d > 0 then 1 else
          if x['start'] < y['start'] then -1
          else if x['start'] > y['start'] then 1
          else 0
      ).each (i, a) =>
        weeks = format_weeks(a['weeks'])
        @echo "  #{rpad(a['code'],13)}  #{a['day'][0..1]}"\
          +"  #{lpad(a['start'], 5)}--#{rpad(a['end'],5)}"\
          +"  #{rpad(a['room'],15)}  #{weeks}"

  @exit()
