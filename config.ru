$:.unshift("#{File.expand_path('..', __FILE__)}/lib")

ENV['RACK_ENV'] ||= 'development'
OSSISTANT_ENV = ENV['RACK_ENV']

require 'ossistant'
require 'dynflow/web_console'

Ossistant.setup_env

run Ossistant::Web

console = Dynflow::WebConsole.setup do
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    settings.web_interface.authentic?(username, password)
  end

  set :bus, Ossistant.persisted_bus
  set :web_interface, Ossistant.config.interfaces.find('ossistant')
end

map('/dynflow') { run(console) }
