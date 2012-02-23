require File.dirname(__FILE__) + '/lib/papertrail.rb'

Heroku::Command::Help.group('Papertrail') do |group|
  group.command 'pt:tail [-t] [query]', "options shows logs matching query (-t = continuously)"
end
