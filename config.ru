$:.unshift("#{File.expand_path('..', __FILE__)}/lib")

ENV['RACK_ENV'] ||= 'development'
OSSISTANT_ENV = ENV['RACK_ENV']

require 'ossistant'

Ossistant.setup_env

run Ossistant::Web
