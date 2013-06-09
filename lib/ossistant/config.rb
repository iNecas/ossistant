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

    def interfaces
      @interfaces ||= Interfaces::Config.new(@interfaces_config)
    end

    def rules
      @rules ||= Rules::Config.new(@rules_config)
    end
  end
end
