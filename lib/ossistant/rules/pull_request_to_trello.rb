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
        configs.each do |config|
          next unless conditions_satisfied?(config)

          case pull_request['action']
          when 'opened'
            card_create_input = {
              'interface' => { 'name' => config['trello_interface'] },
              'card' => card.merge('list_id' => config['trello_list_id']),
            }
            plan_action(Actions::CardCreate, card_create_input)
          when 'closed'
            card_archive_input = {
              'interface' => { 'name' => config['trello_interface'] },
              'card' => {
                'list_id' => config['trello_list_id'],
                'identifier' => card_identifier
              }
            }
            plan_action(Actions::CardArchive, card_archive_input)
          end
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
          'identifier' => card_identifier,
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

      def card_identifier
        "PR #{pull_request['repository']['name']}/#{pull_request['number']}"
      end

      # Says if the given pull request fits the conditions in given configuration.
      # @param [Hash] Rule configuration
      def conditions_satisfied?(config)
        repos = Array(config['repos'])
        unless repos_match?(repos, pull_request['repository'])
          return false
        end
        github_interfaces = Array(config['github_interfaces'])
        if github_interfaces.any? &&
            !github_interfaces.include?(input['interface']['name'])
          return false
        end

        return true
      end

      def repos_match?(repo_names, repo)
        return true if repo_names.empty?
        return repo_names.any? do |repo_name|
          if repo_name.include?('/')
            repo_name == repo['full_name']
          else
            repo_name == repo['name']
          end
        end
      end

    end
  end
end
