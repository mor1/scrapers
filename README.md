Mort's Scraper Scripts
======================

Primarily  excuses to have a go with [CoffeeScript][coffee], [jQuery][], and [PhantomJS][], and later [CasperJS][].

The current (1.9.1) minified version of [jQuery][] is included, under its own license.
 
Developed and run OSX 10.8 using [PhantomJS][] 1.9.0 and [CasperJS][] 1.0.2 installed through [Homebrew](http://mxcl.github.com/homebrew/). Mileage on other platforms may, of course, differ.

You should obey Google's `robots.txt` file if and when you run these or any other scraper scripts.

[PhantomJS]: http://phantomjs.org/
[CasperJS]: http://casperjs.org/
[coffee]: http://coffeescript.org/
[jQuery]: http://jquery.com/


libmort
-------

__todo__


ned-data
--------

__todo__


skol
----

Example:

    $ ./skol.coffee "r mortier" "magpie"

### TODO

+ \[PDF]\[PDF] at the start of the title
+ really need to check the title of the block and move to next if insufficiently good match
+ subtitle not captured by scholar but is in initial entry


uoncourses
----------

Examples:

    $ ./uoncourses.coffee --year=2013/14 --all >| courses.json
    $ ./uoncourses.coffee --year=2013/14 G404 >| g404.json

### TODO

+ remove modules in green as currently deprecated
+ combine corresponding BSc/MSci courses appropriately

uontt
-----
