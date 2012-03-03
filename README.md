# Papertrail Heroku plugin

Extends `heroku` command-line app to also display, tail, and search Heroku 
app logs on Papertrail.


## Usage 

    $ heroku pt:logs [-t] [query]

      -t      # continually stream logs (tail)
      query   # optional search filter (Boolean)


## Example

Add Papertrail's Heroku [log management addon](https://addons.heroku.com/papertrail) to your
app(s), then run `heroku pt:logs`. Examples:

    $ heroku pt:logs 
    $ heroku pt:logs -t
    $ heroku pt:logs -t "Sent mail to" cron
    $ heroku pt:logs -t app web
    $ heroku pt:logs "State changed from" OR "Completed in"


## Installation

    $ heroku plugins:install https://github.com/paptertrail/heroku-plugin


## Development

The tests use an existing Heroku and Papertrail account.
Proceed with caution (and test accounts)

1. Rename test_config.yml.example to test_config.yml
2. Change the fields
3. Run:

    $bundle exec features
