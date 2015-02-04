var Heroku = require('heroku-client');
var https = require('https');
var strftime = require('strftime');

exports.topics = [{
  name: "pt2",
  description: "Search and/or tail logs (optional: tail; search query)"
}];

exports.commands = [{
  topic: "pt2",
  command: "logs",
  description: "Search and/or tail logs (optional: tail; search query)",
  help: "Search and/or tail logs (optional: tail; search query)",
  needsApp: true,
  needsAuth: true,
  run: function (context) {
    var heroku = new Heroku({token: context.auth.password});
    heroku.apps(context.app).configVars().info(function (err, config) {
      if (err) { throw err; }
      if (!config.PAPERTRAIL_API_TOKEN) {
        console.error('Add the Papertrail addon to this application: https://addons.heroku.com/papertrail');
        process.exit(1);
      }

      var options = {
        host: 'papertrailapp.com',
        path: '/api/v1/events/search.json',
        port: '443',
        headers: {'X-Papertrail-Token': config.PAPERTRAIL_API_TOKEN}
      };

      var printEvent = function(event) {
        var received_at = strftime("%b %e %T", new Date(event.received_at));
        console.log(received_at + " " + event.hostname + " " + event.program + ": " + event.message);
      };

      var process = function(data) {
        JSON.parse(data).events.forEach(printEvent);
      };

      callback = function(response) {
        var data = "";

        response.on('data', function (chunk) {
          data += chunk;
        });

        response.on('end', function () {
          process(data);
        });
      }

      https.get(options, callback);
    });
  }
}];
