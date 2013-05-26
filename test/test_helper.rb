ENV['RACK_ENV'] = 'test'
OSSISTANT_ENV='test'

require 'test/unit'
require 'minitest/spec'
require 'rack/test'
require 'ossistant'
require 'mocha/setup'

require 'pry'

test_config = {
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

Ossistant.instance_variable_set('@config', Ossistant::Config.new(test_config))
Ossistant.setup_env

def read_fixture(name)
  File.read(File.expand_path("../fixtures/#{name}", __FILE__))
end
