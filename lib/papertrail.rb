require 'papertrail/connection.rb'

module Heroku::Command
  class Pt < Base
    def self.search(search_query, options = {})
      search_query.search.events.each do |event|
        $stdout.puts event
      end
      $stdout.flush if options[:flush]
    end

    def tail
      options = {:delay => 1} #TODO: configurable delay?
      options[:tail] = args.delete('-t')
      options[:query] = args

      token = heroku.config_vars(app)['PAPERTRAIL_API_TOKEN']
      if token.nil? or token.empty?
        abort "First, please enable the Papertrail addon for this application"
      end

      connection = Papertrail::Connection.new(:token => token)

      search_query = connection.query(options[:query])

      if options[:tail]
        loop do
          self.class.search(search_query, :flush => true)
          sleep options[:delay]
        end
      else
        self.class.search(search_query)
      end
    end
  end
end
