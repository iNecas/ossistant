require 'test_helper'
require 'ostruct'

module Ossistant
  module Importers

    describe PullRequestFromWebhook do

      include Dynflow::Test::Unit

      let(:interface) { ::Ossistant.config.interfaces.find('github') }
      let(:data) { JSON.parse(read_fixture('pull_request_opened.json')) }
      let(:author_data) do
        { 'login'=>'iNecas',
          'name'=>'Ivan Necas',
          'html_url'=>'https://github.com/iNecas',
          'avatar_url'=>'https://secure.gravatar.com/avatar/404.png',
          'email'=>'inecas@redhat.com',
          'company'=>'Red Hat' }
      end
      let(:headers) { { 'HTTP_X_GITHUB_EVENT' => 'pull_request' } }
      let(:request) { OpenStruct.new(:params => data, :env => headers) }
      let(:mocked_github_api) do
        stub = self.stub
        interface.stubs(:api).returns(stub)
        stub
      end

      it 'publishes the pull request event' do
        mocked_github_api.expects('user').with('iNecas').returns(author_data)
        interface.bus = testing_bus
        testing_bus.trigger(Importers::PullRequestFromWebhook, interface.name, request.params)
        action = testing_bus.triggered_action.sub_actions.first

        expected_action_data = {
          "interface"=>{"name"=>"github"},
          "action"=>"opened",
          "author"=> {
            "login"=>"iNecas",
            "name"=>"Ivan Necas",
            "url"=>"https://github.com/iNecas",
            "avatar_url"=>"https://secure.gravatar.com/avatar/404.png",
            "email"=>"inecas@redhat.com",
            "company"=>"Red Hat"
          },
          "repository"=>{"name"=>"trellolo"},
          "url"=>"https://github.com/iNecas/trellolo/pull/3",
          "issue_url"=>"https://github.com/iNecas/trellolo/issues/3",
          "number"=>3,
          "title"=>"Add license",
          "body"=>"Open source code without license is as useful as\n proprietary code without money."
        }

        action.args.first.must_equal expected_action_data
      end
    end
  end
end
