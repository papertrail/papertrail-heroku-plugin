begin
  require File.dirname(__FILE__) + '/lib/papertrail'
rescue LoadError
  raise "papertrail gem is missing. Please install papertrail: gem install papertrail"
end

Heroku::Command::Help.group('Papertrail') do |group|
  group.command 'pt:logs [-t] [query]', 'Show Papertrail logs (optional: tail; filter with query)'
end