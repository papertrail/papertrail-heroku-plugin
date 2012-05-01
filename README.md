# Papertrail Heroku plugin

Extends `heroku` command-line app to display, tail, and search Heroku app and 
platform logs on [Papertrail](https://papertrailapp.com/).


## Installation

    $ heroku plugins:install https://github.com/papertrail/papertrail-heroku-plugin


## Usage

    $ heroku pt:logs [-t] [query]

      -t      # continually stream logs (tail)
      query   # Boolean search filter


## Examples

Add Papertrail's Heroku log management [addon](https://addons.heroku.com/papertrail) to your
app(s), then run `heroku pt:logs`. Examples:

    $ heroku pt:logs
    $ heroku pt:logs -t
    $ heroku pt:logs -t "Sent mail to" cron
    $ heroku pt:logs -t app web
    $ heroku pt:logs "State changed from" OR "Completed in"


## Tests

Prerequisites (gems):

* mocha
* papertrail-cli
* heroku

Run with:

    $ ruby test/papertrail_test.rb
