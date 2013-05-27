module Ossistant
  module Github
    class PullRequest < Dynflow::Action

      input_format do
        param :interface, Hash do
          param :name
        end
        param :action, ['opened', 'closed']
        param :author, Hash do
          param :login
          param :url
          param :email
          param :company
        end
        param :url
        param :issue_url
        param :title
        param :body
      end

      # Transforms the raw data from Github into PullRequest action data
      def plan(interface, raw)
        raw_pr = raw['payload']['pull_request']
        author = interface.api.user(raw_pr['user']['login'])
        plan_self('interface' => { 'name' => interface.name },
                  'action' => raw['payload']['action'],
                  'author' => {
                    'login' => author['login'],
                    'name'  => author['name'],
                    'url'   => author['html_url'],
                    'email' => author['email'],
                    'company' => author['company']
                  },
                  'url' => raw_pr['html_url'],
                  'issue_url' => raw_pr['issue_url'],
                  'title' => raw_pr['title'],
                  'body'  => raw_pr['body'])
      end

    end
  end
end
