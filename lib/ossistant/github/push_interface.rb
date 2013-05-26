require 'openssl'
require 'digest/sha2'

module Ossistant
  module Github
    class PushInterface < Interfaces::Base

      DIGEST = OpenSSL::Digest::Digest.new('sha1')

      attr_reader :secret

      def self.type_name
        'github_push'
      end

      def initialize(config)
        super
        @secret = config['secret']
      end

      def generate_sig(body)
        "sha1=#{OpenSSL::HMAC.hexdigest(DIGEST, secret, body.to_s)}"
      end

      # @param [Sinatra::Request]
      # @return [true, false]
      def authentic?(request)
        request.body.rewind
        body = request.body.read
        sig_client = generate_sig(body)
        sig_server = request.env['HTTP_X_HUB_SIGNATURE']
        if constant_time_equal?(sig_client, sig_server)
          return true
        else
          return false
        end
      end

      def incomming_web_request(request)
        puts "incomming event"
      end
    end
  end
end

