# Papertrail Heroku plugin

Extends `heroku` command-line app to display, tail, and search Heroku app and 
platform logs on [Papertrail](https://papertrailapp.com/).


## Installation

    $ heroku plugins:install https://github.com/papertrail/papertrail-heroku-plugin

The plugin includes all required dependencies.


## Usage

    $ heroku pt:logs [-t] [query]

      -t      # continually stream logs (tail)
      query   # Boolean search filter

    $ heroku addons:open papertrail

## Examples

Add Papertrail's Heroku [log management add-on](https://addons.heroku.com/papertrail) to your
app(s), then run `heroku pt:logs`. Examples:

    $ heroku pt:logs

Tail:

    $ heroku pt:logs -t

Specify a Heroku app name, tail, and show only logs containing `router`:

    $ heroku pt:logs --app wopr -t router

Create shortcuts to invoke CLI or open Web interface:

    $ alias logs="heroku pt:logs --app wopr -t"
    $ logs JoshuaController

    $ alias pt="heroku addons:open --app wopr papertrail"
    $ pt


## Advanced Examples

To search for quoted phrases, enclose entire query in double quotes 
(consistent with other shell tools):

    $ heroku pt:logs "'Sent mail to' cron"
    $ heroku pt:logs -t "'status=50' OR 'Completed in'"

Use parenthesis and exclusion (`-`):

    $ heroku pt:logs --app wopr -t "'State changed' OR (router ('status=50' OR 'Error H'))"
    $ heroku pt:logs "router -'queue=0'"

More: [Search syntax](http://help.papertrailapp.com/kb/how-it-works/search-syntax)
