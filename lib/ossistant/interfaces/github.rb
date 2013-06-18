require 'openssl'
require 'digest/sha2'
require 'octokit'

module Ossistant
  module Interfaces
    class Github < Interfaces::Base

      DIGEST = OpenSSL::Digest::Digest.new('sha1')

      attr_reader :secret, :oauth_token

      def self.type_name
        'github'
      end

      def initialize(config)
        super
        @secret = config['secret']
        @oauth_token = config['oauth_token']
      end

      # the interface for getting additional information
      def api
        @api ||= Octokit::Client.new(:oauth_token => self.oauth_token)
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

      def incoming_web_request(request)
        event_class = case request.env['HTTP_X_GITHUB_EVENT']
                       when 'pull_request'
                         Importers::PullRequestFromWebhook
                       else
                         # TODO: logging
                         nil
                       end
        if event_class
          self.bus.trigger(event_class, self.name, request.params)
          # TODO: logging
        end
      end
    end
  end
end

