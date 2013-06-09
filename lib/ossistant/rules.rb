require 'active_support/inflector'

module Ossistant
  module Rules

    # Every Dynflow action should include this module so that we know
    # that it's realy a rule
    module Base
      def rule_name
        self.class.name[/\w+$/].underscore
      end

      # @returns [Array<Hash>] Set of configurations for this rule
      def configs
        Ossistant.config.rules.all_of_type(self)
      end
    end

    class Config

      attr_reader :rules_config

      # @param [Hash] rules_config
      def initialize(rules_config)
        @rules_config = rules_config
      end

      def all_of_type(rule_class)
        rules_config.find_all do |name, config|
          config['type'] == rule_class.rule_name
        end.map do |(name, config)|
          config.merge('name' => name)
        end
      end

    end
  end
end
