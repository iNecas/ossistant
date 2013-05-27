require 'yaml'

module Ossistant
  class Config

    def initialize(config = nil)
      @config = config || YAML.load_file(config_path)
    end

    def config_path
      File.join(Ossistant.env.root, 'config/ossistant.yml')
    end

    def interface_configs(type)
      @config['interfaces'].find_all do |name, config|
        config['type'] == type
      end.map do |(name, config)|
        config.merge('name' => name)
      end
    end

    def rule_configs(rule)
      @config['rules'].find_all do |name, config|
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
