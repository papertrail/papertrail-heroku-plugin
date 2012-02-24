RAILS_PRJ = 'test1'

# files that make up this heroku plugin
PLUGIN_FILES = ['init.rb', 'lib/papertrail.rb']

Before do
  @app_name = nil
end

After do
  within_rails_dir(RAILS_PRJ) do
    step %Q{I successfully run `heroku apps:destroy #{@app_name} --confirm #{@app_name}`}
  end if @app_name
end

Given /^I have a rails app with git$/ do
  step %Q{I successfully run `rails new #{RAILS_PRJ} --skip-bundle -T -q`}
  within_rails_dir(RAILS_PRJ) do
    step %Q{I successfully run `git init`}
    step %Q{I successfully run `git add -A`}
    step %Q{I successfully run `git commit -m "first commit"`}
  end
end

Given /^it is on heroku$/ do
  heroku = conf['heroku']
  credentials = [heroku['email'], heroku['token']]
  step %Q{a directory named ".heroku"}
  step %Q{a file named ".heroku/credentials" with:}, credentials.join("\n")

  within_rails_dir(RAILS_PRJ) do
    step %Q{I successfully run `heroku create`}
    step %Q{I successfully run `heroku apps:info`}
    @app_name = output_from("heroku apps:info").match(/^=== (.*)$/)[1]
  end
end

Given /^it uses the papertrail addon$/ do
  #TODO: fix when heroku addon leaves private beta
  # pretend papertrail addon already set the variables
  within_rails_dir(RAILS_PRJ) do
    addon = conf['papertrail']['addon']
    step %Q{I successfully run `heroku config:add PAPERTRAIL_API_TOKEN=#{addon['token']}`}
  end
end

When /^I install heroku\-papertrail$/ do
  this_repository = "file://#{Dir.pwd}"
  step %Q{I successfully run `heroku plugins:install #{this_repository}`}

  repo_name = File.basename(Dir.pwd)

  #TODO: copy modified files in a sane way
  PLUGIN_FILES.each do |filename|
    step %Q{I overwrite ".heroku/plugins/#{repo_name}/#{filename}" with:},
      IO.read(filename)
  end
end
