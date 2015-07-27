'use strict';
var extend      = require('util')._extend;
var command     = require('./commands/pt');
var description = "Search and/or tail logs";

// `pt` topic kept for backwards-compatibility.
exports.topics = [{ name: "papertrail", description: description },
                  { name: "pt",         description: description }];

exports.commands = [
  extend({ topic: "pt",         description: description }, command),
  extend({ topic: "papertrail", description: description }, command)
];
