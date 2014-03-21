require 'vendor/papertrail/connection'

module Heroku::Command
  class Pt < BaseWithApp
    DELAY = 1

    def self.search(search_query, options = {})
      search_query.search.events.each do |event|
        $stdout.puts event
      end
      $stdout.flush if options[:flush]
    end

    def logs
      config_vars = Heroku::Auth.api.get_config_vars(app).body

      token = config_vars['PAPERTRAIL_API_TOKEN']
      if token.nil? or token.empty?
        abort 'Add the Papertrail addon to this application (see https://addons.heroku.com/papertrail)'
      end

      connection = Papertrail::Connection.new(:token => token)

      tail = args.delete('-t')
      if args.length > 1
        abort 'To search for phrases, enclose in quotes (see examples: https://github.com/papertrail/papertrail-heroku-plugin)'
      end
      search_query = connection.query(args.first)

      if tail
        loop do
          self.class.search(search_query, :flush => true)
          Kernel.sleep DELAY
        end
      else
        self.class.search(search_query)
      end
    end
  end
end
