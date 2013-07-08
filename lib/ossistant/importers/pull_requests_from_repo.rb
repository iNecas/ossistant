module Ossistant
  module Importers

    class PullRequestsFromRepo < Dynflow::Action

      def plan(interface, repo)
        interface.api.pull_requests(repo).each do |pull_request|
          author = interface.api.user(pull_request['user']['login'])
          repo = pull_request['base']['repo']
          pull_request_data = {
            'interface' => { 'name' => interface.name },
            'action' => 'opened',
            'author' => {
              'login' => author['login'],
              'name'  => author['name'],
              'url'   => author['html_url'],
              'avatar_url' => author['avatar_url'],
              'email' => author['email'],
              'company' => author['company']
            },
            'repository' => {
              'name' => repo['name'],
              'full_name' => repo['full_name']
            },
            'number' => pull_request['number'],
            'url' => pull_request['html_url'],
            'issue_url' => pull_request['issue_url'],
            'title' => pull_request['title'],
            'body'  => pull_request['body']
          }
          plan_action(Events::PullRequest, pull_request_data)
        end
      end

    end

  end
end
