require 'papertrail/connection.rb'

module Heroku::Command
  class Pt < Base
    DELAY = 1

    def self.search(search_query, options = {})
      search_query.search.events.each do |event|
        $stdout.puts event
      end
      $stdout.flush if options[:flush]
    end

    def logs
      token = heroku.config_vars(app)['PAPERTRAIL_API_TOKEN']
      if token.nil? or token.empty?
        abort 'Please add the Papertrail addon to this application'
      end

      connection = Papertrail::Connection.new(:token => token)

      tail = args.delete('-t')
      search_query = connection.query(args)

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
