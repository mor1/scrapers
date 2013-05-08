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

.PHONY: clean sanitise

clean:
	$(RM) CitationsV4.utf8.txt debug.* courses.json [up]gt.json
	$(RM) $(patsubst %.coffee,%.js,$(wildcard *.coffee))

sanitise:
	iconv -f UTF-16 -t UTF-8 CitationsV4.txt >| CitationsV4.utf8.txt
