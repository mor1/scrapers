#!/usr/bin/env python3

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

import sys, os

if __name__ == '__main__':

    with open(sys.argv[1]) as lines:
        for line in [ l.strip().split("\t") for l in lines if l[0] != '#' ]:
            
            names = line[2][:-2]
            title = line[5]
            for c in ":\"'`)": 
                names = names.replace(c, "")
                title = title.replace(c, "")

            names = names.split("(")
            title = title.replace("(", "")
            author = "%s %s" % ("".join(names[1:]).replace(" ",""), names[0].strip())
            os.system('''echo Title:\\\'%s\\\' Author:\\\'%s\\\' && ./skol.coffee "%s" "%s"''' 
                      % (title, author, author, title))
