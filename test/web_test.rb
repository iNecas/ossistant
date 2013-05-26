require 'test_helper'

module Ossistant
  describe Ossistant::Web do

    include Rack::Test::Methods

    def app
      Ossistant::Web
    end

    describe 'post event to interface' do

      let(:data) { {'id' => '123'} }
      let(:body) { JSON(data) }

      it 'passes the event to the right interface' do
        github_interface = Ossistant.config.interfaces.find('github')
        github_interface.expects('incomming_web_request').with do |request|
          request.env['HTTP_X_GITHUB_EVENT'].must_equal 'pull_request'
          request.params.must_equal data
        end
        header 'Content-Type', 'application/json'
        header 'X-Hub-Signature', github_interface.generate_sig(body)
        header 'X-Github-Event', 'pull_request'
        post '/interfaces/github/event', body
      end

      it 'refused the request if not authentic' do
        header 'Content-Type', 'application/json'
        header 'X_Hub_Signature', 'not authentic'
        post '/interfaces/github/event', body
        last_response.status.must_equal 501
      end

    end


  end
end
