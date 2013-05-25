module Ossistant
  module Github
    class PushInterface < Interfaces::Base
      attr_reader :token

      def self.type_name
        'github_push'
      end

      def initialize(config)
        super
        @token = config['token']
      end
    end
  end
end

