# Heroku plugin for papertrail

Papertrail functionality for Heroku based projects.

## Quick Start

  $ heroku plugins:install https://github.com/paptertrail/heroku-paptertrail
  $ heroku pt:tail
  $ heroku pt:tail some search query
  $ heroku pt:tail -t
  $ heroku pt:tail -t some search query

## Integration tests

WARNING: The tests use an existing Heroku and Papertrail account.
WARNING: Proceed with caution or preferably, use test accounts

1. Rename test_config.yml.example to test_config.yml
2. Change the fields
3. Run:

  $bundle exec features
