Mort's Scraper Scripts
======================

Primarily  excuses to have a go with [CoffeeScript][coffee], [jQuery][], and [PhantomJS][], and later [CasperJS][].

Developed and run OSX using [PhantomJS][] and [CasperJS][] installed through [Homebrew](http://mxcl.github.com/homebrew/). Mileage on other platforms may, of course, differ.

Good manners suggests you should obey `robots.txt` files if and when you run these or any other scraper scripts. The law suggests that you should obey any terms and conditions that apply concerning websites and their data.

[PhantomJS]: http://phantomjs.org/
[CasperJS]: http://casperjs.org/
[coffee]: http://coffeescript.org/
[jQuery]: http://jquery.com/


libmort
-------

Some simple helper functions:

+ `lpad`, `rpad`: left/right padding of strings
+ `remotelog`: format assistance for remote strings
+ `dbg` format assistance


ned-data
--------

__todo__


skol
----

Citation data by screen scraping. Supports Google Scholar and Microsoft Academic.

Example:

    $ ./skol-scrape.coffee "r mortier" "magpie"

Python 3 script as a simple harness to read input data from a file provided (read the code for the format):

    $ ./skol.py <input>


uoncourses
----------

Extract information from University of Nottingham course and module directories.

Example:

    $ ./uoncourses.coffee --year=2013/14 --all >| courses.json
    $ ./uoncourses.coffee --year=2013/14 G404 >| g404.json

### TODO

+ remove modules in green as currently deprecated
+ combine corresponding BSc/MSci courses appropriately


uoncrsid
--------

Convert UoN module code to CRSID as used by Saturn.

Example:

    $ ./uoncrsid.coffee --year=2013/14 g54acc g54ccs


uontt
-----

Extract information from University of Nottingham module timetable pages and, optionally, module catalogue (`--details`; rendered only to JSON though).

Example:

    $ ./uontt.coffee g54ccs g54acc
