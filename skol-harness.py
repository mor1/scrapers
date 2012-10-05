#!/usr/bin/env python3

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
