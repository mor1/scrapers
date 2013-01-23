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

## error handling
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
 
casper.on 'remote.alert', (msg) -> @log '[remote-alert] #{msg}', "warn"
                                   
dbg = (m) ->
  c = casper.getColorizer()
  console.error c.colorize "[debug] #{m}", "GREEN", 80
                                 
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

## globals
root = "http://ned.ipac.caltech.edu"
uri = "#{ root }/forms/gmd.html" if is_name
uri = "#{ root }/forms/nnd.html" if is_radec

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
    image_idx = if is_name then 10 else 11

    # when i say table, i mean "literal chunk of ascii text enclosed with
    # <pre></pre> in a single row of a single column in a table". ie., not a
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
  ), { is_name }

## from http://coffeescriptcookbook.com/chapters/arrays/concatenating-arrays
Array::merge = (other) -> Array::push.apply @, other

targets = []        
casper.then ->
  ## having extracted objname-imagelinks mapping, grab link urls
  re = /href=["](.*)["]/i
  for n_obj, links of images
    [n, obj] = n_obj.split("|")
    hrefs = (re.exec(link) for link in links)
    target = ([n,obj,"#{root}#{href[1].replace(/&amp;/g, '&')}"] for href in hrefs)
    targets.merge target

casper.then ->
  @each targets, (self, target) ->
    [oid, oname, url] = target
    @thenOpen target[2], () ->
      mf = fs.open "metadata.txt", "a"
      result = @evaluate (open_target = (target) ->
        result = { 'links': [] }
        $('table tr').slice(1).each(log_row = (i, e) ->
          cells = $("td", this)
          data = $("a", cells[1]).attr("href")

          ## interesting... can't use "x in string" as below in @evaluate
          ## because the autogenerated function __indexOf isn't available in
          ## the remote DOM
          # if "?" not in data

          if data.indexOf("?") == -1
            cpts = data.split(".")
            ext = if data.slice(-".gz".length) == ".gz"
                cpts[cpts.length-2..].join(".")
              else
                cpts[cpts.length-1..].join(".")

            band = $(cells[4]).html().split(",")[0].trim()
            metadata = $(cells[4..]).map((i,c) => $(c).text().trim())
            result['links'].push [data, band, ext, metadata]
        )
        result
      ), { target }
      links = result['links']

      for link in links
        [data, band, ext, metadata] = link
        n = 0
        filename = "object_#{oid}_#{oname}_#{band}_v#{n}.#{ext}"
        while fs.exists(filename)
          n += 1
          filename = "object_#{oid}_#{oname}_#{band}_v#{n}.#{ext}"

        @download data, filename
        metadata = Array::slice.call(metadata) ## explicit cast to Array
        mf.writeLine "#{filename}\t#{oid}\t#{oname}\t#{metadata.join("\t")}"
      mf.close()

casper.run ->
  casper.log "ran!", "info"
  casper.exit()
