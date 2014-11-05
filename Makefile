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

.PHONY: clean courses.json pgt.json ugt.json

clean:
	$(RM) $(patsubst %.coffee,%.js,$(wildcard *.coffee))
	$(RM) data/*.json data/x*

UGT = G400 G404 G4G7 G4G1 G601 GN42
PGT = G507 G565 G403 G402 G440
YEAR = 2014/15
courses.json:
	./uoncourses.coffee --year=$(YEAR) --all >| data/courses.json

ugt.json:
	./uoncourses.coffee --year=$(YEAR) $(UGT) >| data/ugt.json

pgt.json:
	./uoncourses.coffee --year=$(YEAR) $(PGT)  >| data/pgt.json
