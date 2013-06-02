require 'yaml'

module Ossistant
  class Config

    def initialize(interfaces_config = nil, rules_config = nil)
      @interfaces_config = interfaces_config || load_interfaces_config
      @rules_config = rules_config || load_rules_config
    end

    def load_interfaces_config
      YAML.load_file(config_path('interfaces'))
    end

    def load_rules_config
      YAML.load_file(config_path('rules'))
    end

    def config_path(name)
      File.join(Ossistant.env.root, "config/#{name}.yml")
    end

    def interface_configs(type)
      @interfaces_config.find_all do |name, config|
        config['type'] == type
      end.map do |(name, config)|
        config.merge('name' => name)
      end
    end

    def rule_configs(rule)
      @rules_config.find_all do |name, config|
        config['type'] == rule.rule_name
      end.map do |(name, config)|
        config.merge('name' => name)
      end
    end

    def interfaces
      @interfaces ||= Interfaces.new(self)
    end
  end
end
