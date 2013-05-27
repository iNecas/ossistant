require 'test_helper'
require 'ostruct'

module Ossistant
  module Github

    describe 'pull request via push' do

      class ActionStub

        attr_reader :action_class, :args, :input, :output

        def initialize(action_class, args)
          @action_class = acting_class
          @args = args
          @input = Dynflow::Step::Reference.new(self, :input)
          @output = Dynflow::Step::Reference.new(self, :output)
        end

        def inspect
          "#{action_class.name}(#{args.map(&:inspect).join(', ')})"
        end

      end

      # TODO: move to dynflow
      # runs the plan method only for the action itself, preventing
      # calling of the sub action planned, as well as subscribed
      # actions.
      # The planned sub_actions and args are available in `action.sub_actions`
      module OnlyPlanSelf
        def sub_actions
          @sub_actions ||= []
        end

        def plan_action(action_class, *args)
          self.sub_actions << ActionStub.new(action_class, args)
        end
      end

      class TestBus

        attr_reader :trigerred_action

        def trigger(action_class, *args)
          @trigerred_action = action_class.new({}, :reference)
          @trigerred_action.singleton_class.send(:include, OnlyPlanSelf)
          @trigerred_action.plan(*args)
        end

      end

      def dynflow_triggered_action(&block)
        bus = TestBus.new
        Dynflow::Bus.using(bus, &block)
        return bus.trigerred_action
      end

      let(:interface) { Ossistant.config.interfaces.find('github') }
      let(:data) { JSON.parse(read_fixture('pull_request_opened.json')) }
      let(:author_data) do
        { 'login'=>'iNecas',
          'name'=>'Ivan Necas',
          'url'=>'https://github.com/iNecas',
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

      it 'publishes the pull request action' do
        mocked_github_api.expects('user').with('iNecas').returns(author_data)

        action = dynflow_triggered_action do
          interface.incoming_web_request(request)
        end

        expected_action_data = {
          "interface"=>{"name"=>"github"},
          "action"=>"opened",
          "author"=> {
            "login"=>"iNecas",
            "name"=>"Ivan Necas",
            "url"=>nil,
            "email"=>"inecas@redhat.com",
            "company"=>"Red Hat"
          },
          "url"=>"https://github.com/iNecas/trellolo/pull/3",
          "issue_url"=>"https://github.com/iNecas/trellolo/issues/3",
          "title"=>"Add license",
          "body"=>"Open source code without license is as useful as\n proprietary code without money."
        }

        action.input.must_equal expected_action_data
      end
    end
  end
end
