require 'active_support/inflector'

module Ossistant

  # Every Dynflow action should include this module so that we know
  # that it's realy a rule
  module Rule

    def rule_name
      self.class.name[/\w+$/].underscore
    end

    # @returns [Array<Hash>] Set of configurations for this rule
    def configs
      Ossistant.config.rule_configs(self)
    end

  end
end
