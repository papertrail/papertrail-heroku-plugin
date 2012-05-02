begin
  require File.dirname(__FILE__) + '/lib/papertrail'
rescue LoadError
  raise "papertrail gem is missing. Please install papertrail: gem install papertrail"
end

Heroku::Command::Help.group('Papertrail') do |group|
  group.command 'pt:logs [-t] [query]', 'Search and/or tail logs (optional: tail; search query)'
end