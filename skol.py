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

import sys, subprocess, time

def clean_author(author):
    for c in ":\"'`)":
        author = author.replace(c, "")
    names = author.split("(")

    author = "%s %s" % (
        "".join(names[1:]).replace(" ",""), names[0].strip())
    return author

def clean_title(title):
    for c in ":\"'`)":
        title = title.replace(c, "")

    title = title.replace("(", "")
    return title

if __name__ == '__main__':

    start = time.time()
    with open(sys.argv[1]) as lines:
        i = 0
        for line in [ l.strip().split("\t") for l in lines if l[0] != '#' ]:
            i += 1

            title = clean_title(line[5].strip())
            author = clean_author(line[2][:-2])
            print("# %d | '%s' '%s'" % (i, author, title, ))

            p = subprocess.Popen(['./skol-scrape.coffee',
                                  '%s' % (author,),
                                  '%s' % (title,)
                                  ],
                                 stdout=subprocess.PIPE)
            print(p.communicate()[0].decode("utf-8"))

    end = time.time()
    print("start =", time.ctime(start))
    print("end =", time.ctime(end))
    print("elapsed time =", end-start)
