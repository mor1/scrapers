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

exports.lpad = (s, mx) ->
  while s.length < mx then s = " " + s
  s

exports.rpad = (s, mx) ->
  while s.length < mx then s += " "
  s

require = patchRequire(global.require)
colorizer = require('colorizer').create('Colorizer')

exports.remotelog = (typ, msg) ->
  console.log colorizer.colorize "[remote-#{typ}] #{msg}", "WARN_BAR"

exports.dbg = (msg) ->
  console.log colorizer.colorize "[debug] #{msg}", "INFO_BAR"
