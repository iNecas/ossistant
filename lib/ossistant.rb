module Ossistant

  def self.setup_env
    @env = Environment.new
    @env.setup
    load_interfaces
    return @env
  end

  def self.env
    if @env
      return @env
    else
      raise 'Environment was not set yet'
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.load_interfaces
    require 'ossistant/trello'
    require 'ossistant/github'
    require 'ossistant/rules'
    config.interfaces.load
  end

  # Default bus to be used for handling Dynflow actions
  def self.bus
    @bus ||= Dynflow::Bus::ActiveRecordBus.new
  end

end

require 'dynflow'
require 'ossistant/interfaces'
require 'ossistant/rule'
require 'ossistant/config'
require 'ossistant/environment'
require 'ossistant/web'
