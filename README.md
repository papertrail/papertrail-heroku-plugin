# Papertrail Heroku plugin

Extends `heroku` command-line app to also display, tail, and search Heroku 
app logs on Papertrail.


## Usage 

    $ heroku pt:logs [-t] [query]

      -t      # continually stream logs (tail)
      query   # optional search filter (Boolean)


## Examples

Add Papertrail's Heroku log management [addon](https://addons.heroku.com/papertrail) to your
app(s), then run `heroku pt:logs`. Examples:

    $ heroku pt:logs 
    $ heroku pt:logs -t
    $ heroku pt:logs -t "Sent mail to" cron
    $ heroku pt:logs -t app web
    $ heroku pt:logs "State changed from" OR "Completed in"


## Installation

    $ heroku plugins:install https://github.com/papertrail/heroku-plugin


## Tests

Tests rely on existing Heroku and Papertrail accounts. Use test accounts and 
proceed with caution.

   cp test_config.yml.example test_config.yml
   bundle exec features