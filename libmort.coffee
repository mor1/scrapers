#
# Some CoffeeScript scraper helpers.
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

self = {} ## to make module exports easy

colorizer = require('colorizer').create('Colorizer')

## debugging
self.dbg = (m) ->
  console.log colorizer.colorize "[debug] #{m}", "COMMENT"

self.page_error = (msg, ts) ->
  ## format remote page error per casperjs standard; based on casperjs code
  console.error colorizer.colorize "[remote] #{msg}", 'RED_BAR', 80
  for t in ts
    do (t) ->
      m = fs.absolute t.file + ":" + colorizer.colorize t.line, "COMMENT"
      if t['function']
        m += " in " + colorizer.colorize t['function'], "PARAMETER"
      console.error "  #{ m }"

self.remote_alert = (msg) ->
  console.log colorizer.colorize "[remote-alert] #{msg}", "WARN"
  
self.remote_message = (msg) ->
  console.log colorizer.colorize "[remote] #{msg}", "WARN"
  
## string helpers
self.lpad = (s, mx) ->
  while s.length < mx then s = " " + s
  s

self.rpad = (s, mx) ->
  while s.length < mx then s += " "
  s

module.exports = self
