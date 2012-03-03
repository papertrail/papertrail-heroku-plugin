require File.dirname(__FILE__) + '/lib/papertrail.rb'

Heroku::Command::Help.group('Papertrail') do |group|
  group.command 'pt:logs [-t] [query]', 'Show Papertrail logs (optional: tail; filter with query)'
end
