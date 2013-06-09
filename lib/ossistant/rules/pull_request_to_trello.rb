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
        pr = input['pull_request']
        return unless pr['action'] == 'opened'

        author = input['pull_request']['author']
        card = {
          'identifier' => "PR #{pr['repository']['name']}/#{pr['number']}",
          'title' => "#{pr['title']} [#{author['name']}]",
          'body' => <<BODY
Contributor Information
-----------------------

![#{author['name']}](#{author['avatar_url']})

 * Author: **#{author['name']}** <#{author['email']}>
 * Company: #{author['company']}
 * Github ID: [#{author['login']}](#{author['url']})
 * [Pull Request #{pr['number']} Discussion](#{pr['html_url']})
 * [File Diff](#{pr['html_url']}/files)

Pull Request
============
#{pr['body']}
BODY
        }

        configs.each do |config|
          repos = Array(config['repos'])
          if repos.any? && !repos.include?(pr['repository']['name'])
            next
          end
          github_interfaces = Array(config['github_interfaces'])
          if github_interfaces.any? &&
              !github_interfaces.include?(input['interface']['name'])
            next
          end

          trello_interface = config['trello_interface']
          list_id = config['trello_list_id']

          plan_action(Actions::CardCreate, {
                        'interface' => { 'name' => trello_interface },
                        'card' => card.merge('list_id' => list_id),
                      })
        end

      end

    end
  end
end
