module Ossistant
  module Rules
    class PullRequestToTrello < Dynflow::Action

      include Rules::Base

      def self.subscribe
        Events::PullRequest
      end

      input_format do
        param :pull_request, Events::PullRequest.input
      end

      def plan(*args)
        return unless pull_request['action'] == 'opened'

        configs.each do |config|
          next unless conditions_satisfied?(config)

          card_create_input = {
            'interface' => { 'name' => config['trello_interface'] },
            'card' => card.merge('list_id' => config['trello_list_id']),
          }
          plan_action(Actions::CardCreate, card_create_input)
        end

      end

      private

      def pull_request
        input['pull_request']
      end

      # Prepares the card input for Actions::CardCreate
      def card
        author = input['pull_request']['author']
        card = {
          'identifier' =>
            "PR #{pull_request['repository']['name']}/#{pull_request['number']}",
          'title' => "#{pull_request['title']} [#{author['name']}]",
          'body' => <<BODY
Contributor Information
-----------------------

![#{author['name']}](#{author['avatar_url']})

 * Author: **#{author['name']}** <#{author['email']}>
 * Company: #{author['company']}
 * Github ID: [#{author['login']}](#{author['url']})
 * [Pull Request #{pull_request['number']} Discussion](#{pull_request['html_url']})
 * [File Diff](#{pull_request['html_url']}/files)

Pull Request
============
#{pull_request['body']}
BODY
        }
        return card
      end

      # Says if the given pull request fits the conditions in given configuration.
      # @param [Hash] Rule configuration
      def conditions_satisfied?(config)
        repos = Array(config['repos'])
        if repos.any? && !repos.include?(pull_request['repository']['name'])
          return false
        end
        github_interfaces = Array(config['github_interfaces'])
        if github_interfaces.any? &&
            !github_interfaces.include?(input['interface']['name'])
          return false
        end

        return true
      end

    end
  end
end
