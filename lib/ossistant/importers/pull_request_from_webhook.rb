module Ossistant

  module Importers

    class PullRequestFromWebhook < Dynflow::Action

      # Transforms the raw data from Github into PullRequest action data
      def plan(interface_name, raw)
        raw_pr = raw['payload']['pull_request']
        raw_repo = raw['payload']['repository']
        interface = Ossistant.config.interfaces.find(interface_name)
        author = interface.api.user(raw_pr['user']['login'])
        plan_action(Events::PullRequest,
                    'interface' => { 'name' => interface_name },
                    'action' => raw['payload']['action'],
                    'author' => {
                      'login' => author['login'],
                      'name'  => author['name'],
                      'url'   => author['html_url'],
                      'avatar_url' => author['avatar_url'],
                      'email' => author['email'],
                      'company' => author['company']
                    },
                    'repository' => {
                      'name' => raw_repo['name'],
                      'full_name' => raw_repo['full_name']
                    },
                    'number' => raw_pr['number'],
                    'url' => raw_pr['html_url'],
                    'issue_url' => raw_pr['issue_url'],
                    'title' => raw_pr['title'],
                    'body'  => raw_pr['body'])
      end

    end
  end
end
