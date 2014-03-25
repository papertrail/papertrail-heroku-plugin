require 'papertrail-heroku-plugin/vendor/papertrail'

Heroku::Command::Help.group('Papertrail') do |group|
  group.command 'pt:logs [-t] [query]', 'Search and/or tail logs (optional: tail; search query)'
end
