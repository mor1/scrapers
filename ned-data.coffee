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
  verbose: true,
  viewportSize: { width: 1280, height: 640 },
    
  pageSettings: {
    loadImages:  false,
    loadPlugins: false,
    userAgent: '''Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4'''
  }
})

casper.on 'page.error', (msg,ts) ->
  ## format remote page error per casperjs standard; based on casperjs code
  c = @getColorizer()
  console.error c.colorize "[remote] #{msg}", 'RED_BAR', 80
  for t in ts
    do (t) ->
      m = fs.absolute t.file + ":" + c.colorize t.line, "COMMENT"
      if t['function']
        m += " in " + c.colorize t['function'], "PARAMETER"
      console.error "  #{ m }"
 
casper.on 'remote.alert', (m) -> @log '[remote-alert] #{m}', "warn"

## handle cli options
usage = ->
  casper.die "Usage: #{ system.args[3] } [--name|--radec] <datafile>", 1

casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

is_radec = casper.cli.options['radec']
is_name = casper.cli.options['name']
usage() if (is_radec and is_name) or not (is_radec or is_name)

root = "http://ned.ipac.caltech.edu"
uri = "#{ root }/forms/gmd.html" if is_name
uri = "#{ root }/forms/nnd.html" if is_radec
casper.log uri, "debug"

## read input data
data = fs.open(casper.cli.args[0], "r").read()

casper.start uri, ->
  ## fetch base page, check "images" option, complete form
  @click "input[value='link_image']"
  data = { 'uplist': data }
  if is_radec then data['sr_arcsec'] = 30.0
  @fill "form[name='Get_data_by_OBJ']", data, true

images = {}
casper.then ->
  ## iterate over table, creating filename for object and recording metadata
  images = @evaluate ((is_name) ->
    zpad = (s, mx) -> if s.length < mx then zpad("0" + s, mx) else s
    rows = $('td pre').html().trim().split("\n")
    obj_idx = if is_name then 4 else 5
    image_idx = if is_name then 11 else 12

    # when i say table, i mean "literal chunk of ascii text enclosed with
    # <pre></pre> in a single row of a single column in a table. ie., not a
    # table in any useful sense. ffs.
    #
    # indeed, looking at a tcpdump, it appears that the server
    # deterministcally sends the following individual TCP segments:
    #   table headings, enclosed in <strong />
    #   first row, delimited by 0x0D0A
    #   closing trailer (</pre></table></a>...Back to NED...</body></html>
    # in the right place in seqno space
    #   second row, delimited by 0x0D0A
    # ...and then all gaps are filled, so we 4-way close
    #
    # so i guess we go with some kind of line-based iterator?!

    images = {}
    for i in (i for i in [4...rows.length]) # ignore header rows
      do (rows, i) ->
        cols = rows[i].split("|")
        obj = cols[obj_idx].replace(/\s+/g, '').toUpperCase()
        n = zpad(""+(i-3), (""+rows.length).length)
        n_obj = "#{n}|#{obj}"
        image_url = cols[image_idx]
        if n_obj of images
          images[n_obj].push image_url
        else
          images[n_obj] = [cols[image_idx]]

    images
  ), { is_name, images }
    
casper.then ->
  ## having extracted objname-imagelinks mapping, grab link urls
  re = /href=["](.*)["]/i
  for n_obj, links of images
    [n, obj] = n_obj.split("|")
    hrefs = (re.exec(link) for link in links)
    for href in hrefs
      url = "#{root}#{href[1].replace(/&amp;/g, '&')}"
      @echo "#{n} -- #{obj} -- #{url}", "INFO"

# navigate to url
# for each row in table
  # data = target-of-col[2] (Retrieve link)
  # band = col[5].split(",")[0]
  # ext = extension-of-target-of-col[2] (Retrieve link)
  # filename = object_#{n}_#{obj}_#{band}.#{ext}
  # if filename exists
    # filename = #{filename}.v#{count filenames}
  # save data as filename
  # append to metadata.txt: n, obj, cols[5-9]

casper.run ->
  casper.log "ran!", "info"
  casper.exit()
