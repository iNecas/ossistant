require 'active_record'
require 'yaml'
require 'erb'

module Ossistant
  class Environment

    attr_accessor :name, :root

    def initialize
      @name = OSSISTANT_ENV
      @root = File.expand_path('../../..', __FILE__)
    end

    def setup
      setup_db
    end

    def setup_db
      connect_db
      ActiveRecord::Migrator.migrations_paths += [Dynflow::Bus::ActiveRecordBus.migrations_path]
    end

    def db_config_path
      File.join(root, 'config/database.yml')
    end

    def db_config
      return @db_config if @db_config
      all_db_config = YAML.load(ERB.new(File.read(db_config_path)).result)
      @db_config = all_db_config[self.name]
      return @db_config
    end

    def load_db_driver
      case db_config['adapter']
      when 'sqlite3' then require 'sqlite3'
      when 'postgresql' then require 'postgresql'
      else raise "Unsupported adapter #{db_config['adapter']}"
      end
    end

    def connect_db
      load_db_driver
      ActiveRecord::Base.establish_connection(db_config)
    end
  end

end
