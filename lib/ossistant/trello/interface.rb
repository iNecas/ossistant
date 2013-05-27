require 'trello'

module Ossistant
  module Trello
    class Interface < Interfaces::Base
      attr_reader :key, :secret, :token

      def self.type_name
        'trello'
      end

      def initialize(config)
        super
        @key = config['key']
        @secret = config['secret']
        @token = config['token']
      end

      def api
        @api ||= ::Trello::Client.new(:consumer_key => key,
                                      :consumer_secret => secret,
                                      :oauth_token => token)
      end

    end
  end
end

