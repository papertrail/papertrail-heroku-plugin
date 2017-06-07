'use strict';
var h      = require('heroku-cli-util');
var https  = require("https");
var qs     = require("querystring");
const co   = require("co");

var tailDelay = 1000;

var printEvent = function(event) {
  console.log(event.received_at + " " + event.hostname + " " + event.program + ": " + event.message);
};

var process = function(data) {
  var parsedData = JSON.parse(data);
  parsedData.events.forEach(printEvent);
  return parsedData.max_id;
};

var search = function(token, query, tail, minId) {
  var path = "/api/v1/events/search.json";
  if (query || minId) {
    path += "?";
    if (query) { path += qs.stringify({q: query}); }
    if (path && query) { path += "&"; }
    if (minId) { path += qs.stringify({min_id: minId}); }
  }

  var options = {
    host: "papertrailapp.com",
    path: path,
    port: 443,
    headers: {"X-Papertrail-Token": token}
  };

  var maxId;
  var callback = function(response) {
    var data = "";

    response.on("data", function (chunk) {
      data += chunk;
    });

    response.on("end", function () {
      maxId = process(data);

      if (tail) {
        setTimeout(function() { search(token, query, tail, maxId); }, tailDelay);
      }
    });
  };

  https
    .get(options, callback)
    .on('error', function(e) {
      console.error("ERROR:" + e);
    });
};

module.exports = {
  help: "Shows the most recent logs matching an optional search query.",
  needsApp: true,
  needsAuth: true,
  flags: [{name: "tail", char: "t", hasValue: false, description: "stream new logs in as they're received"}],
  args: [{name: "query", optional: true}],
  run: co.wrap(h.command(function* (context, heroku) {
    var config = yield heroku.apps(context.app).configVars().info();
    if (!config.PAPERTRAIL_API_TOKEN) {
      throw new Error("Add the Papertrail add-on to this application: https://addons.heroku.com/papertrail");
    }
    search(config.PAPERTRAIL_API_TOKEN, context.args.query, context.flags.tail);
  }))
};
