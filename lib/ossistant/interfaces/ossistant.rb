require 'openssl'
require 'digest/sha2'
require 'octokit'

module Ossistant
  module Interfaces

    # access to the web UI dynflow console to see what's going on in ossistant
    class Ossistant < Interfaces::Base
      attr_reader :login, :password

      def self.type_name
        'ossistant'
      end

      def initialize(config)
        super
        @login = config['login']
        @password = config['password']
      end

      # @return [true, false]
      def authentic?(username, password)
        if constant_time_equal?(username, self.login) &&
            constant_time_equal?(password, self.password)
          return true
        else
          return false
        end
      end

    end
  end
end
