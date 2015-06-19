'use strict';
exports.topic = {
  name: "pt",
  description: "Search and/or tail logs"
};

exports.commands = [
  require('./commands/pt')
];
