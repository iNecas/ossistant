module Ossistant
  module Events
    class PullRequest < Dynflow::Action

      input_format do
        param :interface, Hash do
          param :name
        end
        param :action, ['opened', 'closed']
        param :author, Hash do
          param :login
          param :name
          param :avatar_url
          param :url
          param :email
          param :company
        end
        param :repository, Hash do
          param :name
        end
        param :number
        param :url
        param :issue_url
        param :title
        param :body
      end

      # Transforms the raw data from Github into PullRequest action data
      def plan(interface, raw)
        raw_pr = raw['payload']['pull_request']
        raw_repo = raw['payload']['repository']
        author = interface.api.user(raw_pr['user']['login'])
        plan_self('interface' => { 'name' => interface.name },
                  'action' => raw['payload']['action'],
                  'author' => {
                    'login' => author['login'],
                    'name'  => author['name'],
                    'url'   => author['html_url'],
                    'avatar_url' => author['avatar_url'],
                    'email' => author['email'],
                    'company' => author['company']
                  },
                  'repository' => { 'name' => raw_repo['name'] },
                  'number' => raw_pr['number'],
                  'url' => raw_pr['html_url'],
                  'issue_url' => raw_pr['issue_url'],
                  'title' => raw_pr['title'],
                  'body'  => raw_pr['body'])
      end

      # just to store the output
      # TODO in Dynflow: every action with plan_self action should store a run step
      def run; end

    end
  end
end
