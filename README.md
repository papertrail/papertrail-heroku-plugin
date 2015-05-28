# Deprecated

This plugin has been deprecated. Instead,
install [this newer plugin](https://www.npmjs.com/package/heroku-papertrail)
with:

    $ heroku plugins:install heroku-papertrail


### Papertrail Heroku plugin (deprecated)

Extends `heroku` command-line app to display, tail, and search Heroku app and 
platform logs on [Papertrail](https://papertrailapp.com/).


## Installation

    $ heroku plugins:install heroku-papertrail

The plugin includes all required dependencies.


## Usage

    $ heroku pt [-t] [query]

      -t      # continually stream logs (tail)
      query   # Boolean search filter

    $ heroku addons:open papertrail

## Examples

Add Papertrail's Heroku [log management add-on](https://addons.heroku.com/papertrail) to your
app(s), then run `heroku pt`. Examples:

    $ heroku pt

Tail:

    $ heroku pt -t

Specify a Heroku app name, tail, and show only logs containing `router`:

    $ heroku pt --app wopr -t router

Create shortcuts to invoke CLI or open Web interface:

    $ alias logs="heroku pt --app wopr -t"
    $ logs JoshuaController

    $ alias pt="heroku addons:open --app wopr papertrail"
    $ pt


## Advanced Examples

To search for quoted phrases, enclose entire query in double quotes 
(consistent with other shell tools):

    $ heroku pt "'Sent mail to' cron"
    $ heroku pt -t "'status=50' OR 'Completed in'"

Use parenthesis and exclusion (`-`):

    $ heroku pt --app wopr -t "'State changed' OR (router ('status=50' OR 'Error H'))"
    $ heroku pt "router -'queue=0'"

More: [Search syntax](http://help.papertrailapp.com/kb/how-it-works/search-syntax)
