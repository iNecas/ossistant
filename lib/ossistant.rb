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
    config.interfaces.load
  end

  # Default bus to be used for handling Dynflow actions
  def self.bus
    if ENV['NO_DELAYED'] == 'true'
      @bus ||= self.persisted_bus
    else
      @bus ||= Ossistant::DelayedBus.new
    end
  end

  # persisted bus implementatin
  def self.persisted_bus
    @persisted_bus ||= Dynflow::Bus::ActiveRecordBus.new
  end

end

require 'dynflow'
require 'ossistant/delayed_bus'
require 'ossistant/interfaces'
require 'ossistant/rules'
require 'ossistant/config'
require 'ossistant/environment'
require 'ossistant/web'

# Github
require 'ossistant/interfaces/github'
require 'ossistant/events/pull_request'

# Trello
require 'ossistant/interfaces/trello'
require 'ossistant/actions/card_create.rb'

# Github <-> Trello
require 'ossistant/rules/pull_request_to_trello'

