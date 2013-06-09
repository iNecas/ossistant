require 'test_helper'

module Ossistant
  module Rules

    describe PullRequestToTrello do

      include Dynflow::Test::Unit

      let(:pull_request_data) do
        {
          "interface" => {"name"=>"github"},
          "action" => "opened",
          "author" => {
            "login" => "iNecas",
            "name" => "Ivan Necas",
            "url" => "https://github.com/iNecas",
            "avatar_url" => "https://secure.gravatar.com/avatar/404.png",
            "email" => "inecas@redhat.com",
            "company" => "Red Hat"
          },
          "repository" => {"name" => "trellolo"},
          "url" => "https://github.com/iNecas/trellolo/pull/3",
          "issue_url" => "https://github.com/iNecas/trellolo/issues/3",
          "number" => 3,
          "title" => "Add license",
          "body" => "Open source code without license is as useful as\n proprietary code without money."
        }
      end

      let(:rules_config) do
        {
          'pr_to_trello' => {
            'type' => 'pull_request_to_trello',
            'trello_interface' => 'my_trello',
            'trello_list_id' => '123456'
          }
        }
      end

      let(:triggered_action) do
        testing_bus.trigger(Rules::PullRequestToTrello) do |action|
          action.input['pull_request'] = pull_request_data
        end
        testing_bus.triggered_action
      end

      let(:expected_card_create_input) do
        {
          "interface" => {
            "name" => "my_trello"
          },
          "card" => {
            "identifier" => "PR trellolo/3",
            "title" => "Add license [Ivan Necas]",
            "body"=> <<BODY,
Contributor Information
-----------------------

![Ivan Necas](https://secure.gravatar.com/avatar/404.png)

 * Author: **Ivan Necas** <inecas@redhat.com>
 * Company: Red Hat
 * Github ID: [iNecas](https://github.com/iNecas)
 * [Pull Request 3 Discussion]()
 * [File Diff](/files)

Pull Request
============
Open source code without license is as useful as
 proprietary code without money.
BODY
            "list_id"=>"123456"
          }
        }
      end

      before do
        Ossistant.config.rules.stubs(:rules_config).returns(rules_config)
      end

      it 'should create a corresponding card in Trello' do
        planned_action = triggered_action.sub_actions.first
        planned_action.action_class.must_equal Ossistant::Actions::CardCreate

        card_create_input = planned_action.args.first
        card_create_input.must_equal expected_card_create_input
      end

    end
  end
end
