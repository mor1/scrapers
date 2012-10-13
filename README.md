Skol, a Google Scholar Scraper
==============================

Primarily an excuse to have a go with [CoffeeScript][coffee] and [PhantomJS][].

This script is invoked as, e.g.,

    ./skol.coffee "r mortier" "magpie"
    
It relies on [PhantomJS][], using its in-built support for [CoffeeScript][coffee], as well as [jQuery][] and [JavaScript Debug][debug], the latest minified release of each of which is included under their own licenses and copyrights.

I developed and run this on OSX 10.6 using [PhantomJS][] 1.6.1 installed through [Homebrew](http://mxcl.github.com/homebrew/). Mileage on other platforms may, of course, differ.

You should obey Google's `robots.txt` file if and when you run this script (or any other scraper for that matter).

[PhantomJS]: http://phantomjs.org/
[coffee]: http://coffeescript.org/
[jQuery]: http://jquery.com/
[debug]: http://benalman.com/projects/javascript-debug-console-log/


TODO
----

+ \[PDF]\[PDF] at the start of the title
+ really need to check the title of the block and move to next if insufficiently good match
+ subtitle not captured by scholar but is in initial entry
