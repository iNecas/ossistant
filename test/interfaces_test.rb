require 'test_helper'

module Ossistant

  describe Interfaces do

    let(:config) do
      config_data = {
        'interfaces' => {
          'trello' => {
            'type' => 'trello',
            'key' => 'trello_key',
            'secret' => 'trello_secret',
            'token' => 'trello_token'
          },
          'github' => {
            'type' => 'github_push',
            'token' => 'github_token'
          }
        }
      }

      Config.new(config_data)
    end

    subject do
      interface = Interfaces.new(config)
      interface.instance_variable_set('@types', [Github::PushInterface, Trello::Interface])
      interface.load
      interface
    end

    it 'preloads the interfaces from configuration' do
      github, trello = subject.interfaces.sort_by(&:name)
      github.class.must_equal Ossistant::Github::PushInterface
      github.name.must_equal 'github'
      github.token.must_equal 'github_token'
    end

  end

end
