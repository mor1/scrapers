Skol, a Google Scholar Scraper
==============================

Primarily an excuse to have a go with [CoffeeScript][coffee] and [PhantomJS][].

This script is invoked as, e.g.,

    ./skol.coffee "r mortier" "magpie"
    
It relies on [PhantomJS][], using its in-built support for [CoffeeScript][coffee], as well as [jQuery][], the latest minified release of which is included -- note that jQuery is used under its own license. 

I developed and run this on OSX 10.6 using [PhantomJS][] 1.6.1 installed through [Homebrew](http://mxcl.github.com/homebrew/). Mileage on other platforms may, of course, differ.

You should obey Google's `robots.txt` file if and when you run this script (or any other scraper for that matter).

[PhantomJS]: http://phantomjs.org/
[coffee]: http://coffeescript.org/
[jQuery]: http://jquery.com/
