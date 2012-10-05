#!/usr/bin/env python3

import sys, os

if __name__ == '__main__':

    with open(sys.argv[1]) as lines:
        for line in [ l.strip().split("\t") for l in lines if l[0] != '#' ]:
            
            names = line[2][:-2].strip('"').strip(")").split("(")
            author = "%s %s" % ("".join(names[1:]).replace(" ",""), names[0])
            title = line[5].strip('"')
            os.system('echo Title:\\\'%s\\\' Author:\\\'%s\\\' && ./skol.coffee "%s" "%s"' %
                      (title, author, author, title))
