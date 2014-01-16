#!/usr/bin/env casperjs

# Copyright (C) 2014 Richard Mortier <mort@cantab.net>. All Rights Reserved.
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
fs = require 'fs'
utils = require 'utils'

casper = require('casper').create({
  clientScripts:  [
    './jquery-2.0.3.min.js'
  ],

  logLevel: "warning", ## debug",
  verbose: true,
  viewportSize: { width: 1280, height: 640 },

  pageSettings: {
    loadImages:  false,
    loadPlugins: false,
    userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
  }
})

## handle cli options
usage = ->
  casper.die "Usage: #{ system.args[3] } <grant-codes...>", 1

casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

grants = casper.cli.args
root = "http://gow.epsrc.ac.uk"

## entry point
data = {}

casper.start -> dbg "starting"
casper.then ->
  $(grants).each( (i, grant) ->
    uri = "#{ root }/NGBOViewGrant.aspx?GrantRef=#{ grant }"
    casper.then -> casper.open uri
    casper.then ->
      [grantref, datum] = @evaluate (() ->
        grantref = $('span#lblGrantReference').text()
        title = $('span#lblTitle').text()
        pi = $('a#hlPrincipalInvestigator').next('a').text()

        cis = $('td:contains("Other Investigators")').next().find('td > a')
            .map((i,e) -> {name: $(e).text().trim(), url:e.href})
            .toArray()

        partners = $('table[summary="partners"] td')
            .map((i,e) -> $(e).text().trim())
            .toArray()

        department = $('span#lblDepartment').text()
        organisation = {
            name: $('span#lblOrganisation').text(),
            url: $('td:contains("Organisation Website") ~ td > a')[0].href
          }

        scheme = $('span#lblAwardType').text()
        starts = $('span#lblStarts').text()
        ends = $('span#lblEnds').text()

        ## amusingly, the "title" attribute of this has the value to pennies
        value = $('span#lblValue').text()

        topics = $('table[summary="topic classifications"] td')
            .map((i,e) -> $(e).text().trim())
            .filter((i) -> @.length > 0)
            .toArray()

        sectors = $('table[summary="sector classifications"] td')
            .map((i,e) -> $(e).text().trim())
            .filter((i) -> @.length > 0)
            .toArray()

        abstract = $('span#lblAbstract').text()

        [ grantref,
          {
            title: title,
            pi: pi,
            cis: cis,
            partners: partners,
            department: department,
            organisation: organisation,
            scheme: scheme,
            starts: starts,
            ends: ends,
            value: value,
            topics: topics,
            sectors: sectors,
            abstract: abstract,
          }
        ]
      ), {}
      data[grantref] = datum
  )

casper.run ->
  @echo JSON.stringify {
    tool: '<a href="https://github.com/mor1/scrapers/blob/master/gow-epsrc.coffee">gow-epsrc.coffee</a>',
    date: (new Date()).toString(),
    data: data
    }
  @exit()
