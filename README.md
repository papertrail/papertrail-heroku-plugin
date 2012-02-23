# Heroku plugin for papertrail

Papertrail functionality for Heroku based projects.


## Quick Start

  $ heroku plugins:install https://github.com/paptertrail/heroku-paptertrail
  $ heroku pt:tail
  $ heroku pt:tail some search query
  $ heroku pt:tail -t
  $ heroku pt:tail -t some search query

## Integration tests

Rename test_config.yml.example to test_config.yml, using a heroku test
account (with no projects you are afraid of loosing!).

Then run:

  $ bundle exec rspec
  $ bundle exec features
