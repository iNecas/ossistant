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
      # just to store the output
      # TODO in Dynflow: every action with plan_self action should store a run step
      def run; end

    end
  end
end
