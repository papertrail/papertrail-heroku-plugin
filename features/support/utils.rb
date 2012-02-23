def conf
  @conf ||= YAML.load_file('test_config.yml')
end

def within_rails_dir(project)
  step %Q{I cd to "#{project}"}
  yield
  step %Q{I cd to ".."}
end

def kill_interactive_processes
  return unless @kill_cmd

  #TODO: childprocess doesn't expose an api to send INT
  pid = get_process(@kill_cmd).instance_variable_get(:@process).pid
  ::Process.kill 'INT', pid
  @kill_cmd = nil
end

def diff_logs!(expected, actual)
  # find lines with marker
  # and sort by event date, not log date
  regexp = /^.*\[(.*)\]\s*WARN -- : (.*) #{@marker}$/
  msgs = actual.lines.grep(regexp) {|_| [$1,$2] }.sort.map(&:last)
  msgs.should == expected.lines.map(&:strip)
end
