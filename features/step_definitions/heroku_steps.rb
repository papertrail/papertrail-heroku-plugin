#TODO: use webmock

Before do
  # hex string to make sure previous logs don't count
  # (could have used the #pid but webmock is planned)
  @marker ="test_id:#{(2**32-1 - rand * 2**31).to_i.to_s(16)}"

  #TODO: lost UDP packets may cause tests to fail
  papertrail = conf['papertrail']['syslog']
  @logger = RemoteSyslogLogger.new(papertrail['host'], papertrail['port'])
end

After do
  kill_interactive_processes
end

Given /^the following new logs:$/ do |string|
  string.lines.each do |line|
    @logger.warn "#{line.strip} #{@marker}"
  end
end

And /^I wait for new logs$/ do
  #TODO: wait for io instead?
  sleep 6 # send + pt server + hpt :delay + htp fetch + htp flush
end

When /^I (successfully )?run `([^`]*)` within the project$/ do |success, cmd|
  @cmd = cmd
  within_rails_dir(RAILS_PRJ) do
    step %Q{I #{success }run `#{cmd}`}
  end
end

And /^I start `([^`]*)` within the project$/ do |cmd|
  @cmd,@kill_cmd = cmd,cmd

  within_rails_dir(RAILS_PRJ) do
    step %Q{I run `#{cmd}` interactively}
  end

  #heroku plugin takes ages to finish first search (8sec)
  sleep 10
end

Then /^I should see these logs:$/ do |expected|
  diff_logs!(expected, output_from(@cmd))
end

When /^I press Ctrl\-C$/ do
  kill_interactive_processes
end

Then /^I should see these logs before Ctrl\-C:$/ do |expected|
  actual = output_from(@cmd) # read before Ctrl-c and flush
  step %Q{I press Ctrl-C}
  diff_logs!(expected, actual)
end
