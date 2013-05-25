require 'dynflow'
require 'ossistant/environment'

module Ossistant

  def self.setup_env
    @env = Ossistant::Environment.new
    @env.setup
    return @env
  end

  def self.env
    if @env
      return @env
    else
      raise 'Environment was not set yet'
    end
  end

end
