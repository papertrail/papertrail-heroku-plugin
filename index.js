var Heroku = require("heroku-client");
var https = require("https");
var qs = require("querystring");
var strftime = require("strftime");

exports.topics = [{
  name: "pt2",
  description: "Search and/or tail logs"
}];

exports.commands = [{
  topic: "pt2",
  command: "logs",
  description: "Search and/or tail logs",
  help: "\n\
 Shows the most recent logs matching an optional search query. \n\
 Use --tail to stream new logs in as they're received.",

  needsApp: true,
  needsAuth: true,
  flags: [{name: "tail", char: 0x0074, hasValue: false}],
  args: [{name: "query", optional: true}],
  run: function (context) {
    new Heroku({token: context.auth.password})
      .apps(context.app)
      .configVars()
      .info(function (err, config) {
        if (err) { throw err; }
        if (!config.PAPERTRAIL_API_TOKEN) {
          console.error("Add the Papertrail add-on to this application: https://addons.heroku.com/papertrail");
          process.exit(1);
        }

        search(config.PAPERTRAIL_API_TOKEN, context.args.query, context.args.tail);
      });
  }
}];


var tailDelay = 1000;

var printEvent = function(event) {
  var received_at = strftime("%b %e %T", new Date(event.received_at));
  console.log(received_at + " " + event.hostname + " " + event.program + ": " + event.message);
};

var process = function(data) {
  var parsedData = JSON.parse(data);
  parsedData.events.forEach(printEvent);
  return parsedData.max_id;
};

var search = function(token, query, tail, minId) {
  path = "/api/v1/events/search.json";
  if (query || minId) {
    path += "?";
    if (query) { path += qs.stringify({q: query}); }
    if (path && query) { path += "&"; }
    if (query) { path += qs.stringify({min_id: minId}); }
  }

  var options = {
    host: "papertrailapp.com",
    path: path,
    port: 443,
    headers: {"X-Papertrail-Token": token}
  };

  var maxId;
  callback = function(response) {
    var data = "";

    response.on("data", function (chunk) {
      data += chunk;
    });

    response.on("end", function () {
      maxId = process(data);

      if (tail) {
        setTimeout(function() { search(token, query, tail, maxId) }, tailDelay);
      }
    });
  }

  https
    .get(options, callback)
    .on('error', function(e) {
      console.error("ERROR:" + e);
    });
};
