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
  verbose: false,
  viewportSize: { width: 1280, height: 640 },
    
  pageSettings: {
    loadImages:  false,
    loadPlugins: false,
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

## handle options
usage = ->
  casper.die "Usage: #{ system.args[3] } <modulecode>", 1

casper.cli.drop("cli")
casper.cli.drop("casper-path")
if casper.cli.args.length == 0 and Object.keys(casper.cli.options).length == 0
  usage()

## globals
tt_url = "http://uiwwwsci01.ad.nottingham.ac.uk:8003/reporting/Spreadsheet;module;id"
tt_url_params = "template=SWSCUST+Module+Spreadsheet&weeks=1-52"

module_map = {
  "G50PRO": "018563" ,
  "G50WEB": "018561" ,
  "G51APS": "016658" ,
  "G51CSA": "002235" ,
  "G51DBS": "016949" ,
  "G51FSE": "021236" ,
  "G51FUN": "007252" ,
  "G51IAI": "016973" ,
  "G51MCS": "010233" ,
  "G51OOP": "021233" ,
  "G51PRG": "012192" ,
  "G51REQ": "021185" ,
  "G51TUT": "019438" ,
  "G51UST": "017010" ,
  "G51WPS": "017011" ,
  "G52ADS": "007255" ,
  "G52AFP": "018180" ,
  "G52APR": "021311" ,
  "G52APT": "021245" ,
  "G52CCN": "002252" ,
  "G52CON": "002253" ,
  "G52CPP": "022258" ,
  "G52GRP": "008415" ,
  "G52GUI": "018177" ,
  "G52HCI": "018255" ,
  "G52IFR": "021216" ,
  "G52IMO": "021246" ,
  "G52MAL": "018194" ,
  "G52PAS": "021232" ,
  "G52SEM": "021243" ,
  "G52TUT": "019439" ,
  "G53ARS": "023421" ,
  "G53ASD": "010236" ,
  "G53BIO": "015709" ,
  "G53CCT": "021220" ,
  "G53CMP": "021224" ,
  "G53COM": "002268" ,
  "G53CWO": "023374" ,
  "G53DOC": "021231" ,
  "G53ELC": "010238" ,
  "G53FUZ": "023393" ,
  "G53GRA": "021221" ,
  "G53IDA": "002272" ,
  "G53IDE": "004962" ,
  "G53IDJ": "008416" ,
  "G53IDS": "008462" ,
  "G53IDY": "019309" ,
  "G53KRR": "018195" ,
  "G53NMD": "021217" ,
  "G53OPS": "002276" ,
  "G53ORO": "018252" ,
  "G53SEC": "018176" ,
  "G53SQM": "022254" ,
  "G54999": "022992" ,
  "G54ACC": "021237" ,
  "G54ADM": "021235" ,
  "G54ALG": "021249" ,
  "G54ARC": "021250" ,
  "G54CCS": "022256" ,
  "G54CON": "021816" ,
  "G54DIA": "021226" ,
  "G54DMT": "021183" ,
  "G54FOP": "018385" ,
  "G54FPP": "021251" ,
  "G54GRP": "021788" ,
  "G54IHC": "021190" ,
  "G54INT": "021787" ,
  "G54MDP": "021255" ,
  "G54MET": "021188" ,
  "G54MGA": "023468" ,
  "G54MGP": "021253" ,
  "G54MIA": "023470" ,
  "G54MIP": "021254" ,
  "G54MXR": "021189" ,
  "G54ORM": "021489" ,
  "G54PDC": "021257" ,
  "G54PLP": "020241" ,
  "G54PRG": "021227" ,
  "G54PRO": "019348" ,
  "G54RP2": "022041" ,
  "G54RPS": "020837" ,
  "G54SAI": "022270" ,
  "G54SIM": "021202" ,
  "G54SUM": "021817" ,
  "G54UBI": "019275" ,
  "G54URP": "020240" ,
  "G64ADS": "018384" ,
  "G64DBS": "012353" ,
  "G64DEC": "023529" ,
  "G64HCI": "022388" ,
  "G64ICP": "006637" ,
  "G64INC": "013184" ,
  "G64MIT": "006640" ,
  "G64OOS": "009759" ,
  "G64PIT": "013747" ,
  "G64PMI": "013746" ,
  "G64PRE": "018518" ,
  "G64SPM": "013183" ,
  "G64SWE": "009760" ,
  }
  
## setup uri
mids = casper.cli.args.map((mcode) -> module_map[mcode.toUpperCase()]).join("\n")
usage() if (mids == "")
uri = "#{tt_url};#{encodeURIComponent(mids)}?#{tt_url_params}"

casper.start uri, ->
  tts = @evaluate () ->
    tts = []
    tt = {}
    $("body > table").each (i,table) ->
      switch i % 4
        when 0
          if i != 0 
            tts.push tt
            tt = {}
          
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
    tts.push tt
    tts
  @echo JSON.stringify tts
    
casper.run ->
  casper.exit()
