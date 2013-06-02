ENV['RACK_ENV'] = 'test'
OSSISTANT_ENV='test'

require 'test/unit'
require 'minitest/spec'
require 'rack/test'
require 'ossistant'
require 'mocha/setup'
require 'dynflow/test/unit'

require 'pry'

interfaces_config = {
  'trello' => {
    'type' => 'trello',
    'key' => 'trello_key',
    'secret' => 'trello_secret',
    'token' => 'trello_token'
  },
  'github' => {
    'type' => 'github_push',
    'secret' => 'github_secret'
  }
}

rules_config = {}

config = Ossistant::Config.new(interfaces_config, rules_config)
Ossistant.instance_variable_set('@config', config)
Ossistant.setup_env

def read_fixture(name)
  File.read(File.expand_path("../fixtures/#{name}", __FILE__))
end
