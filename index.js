'use strict';
let extend      = require("util")._extend;
let logsCommand = require('./commands/pt');

exports.topics = [{
  name: "pt",
  description: "Search and/or tail logs"
}];

let legacyLogsCommand = extend({}, logsCommand);
legacyLogsCommand.command = 'logs';
legacyLogsCommand.description = "Identical to `pt` kept only for backwards compatibility";

exports.commands = [logsCommand, legacyLogsCommand];
