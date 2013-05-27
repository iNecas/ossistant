require 'rack/contrib'
require 'json'
require 'sinatra/base'
require 'sinatra/json'

module Ossistant
  class Web < Sinatra::Base

    use Rack::PostBodyContentTypeParser

    helpers Sinatra::JSON

    helpers do
      def respond(status, message)
        halt status, json(:message => message)
      end
    end

    post '/interfaces/:interface/event' do |interface_name|
      interface = Ossistant.config.interfaces.find(interface_name)

      respond 404, "Interface with name #{interface_name} not found" unless interface
      respond 501, 'Unauthorized' unless interface.authentic?(request)

      interface.incoming_web_request(request)
      respond 202, "Processing"
    end

  end
end
