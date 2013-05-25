module Ossistant
  class Interfaces

    class Base

      attr_reader :name

      def initialize(config)
        @name = config['name']
      end

      def self.inherited(klass)
        Ossistant.config.interfaces.types << klass
      end

    end

    attr_reader :interfaces, :types

    # @param [Ossistant::Config]
    def initialize(config)
      @config = config
      @types = []
      @interfaces = []
    end

    def load
      @types.each do |klass|
        @config.interface_configs(klass.type_name).each do |config|
          @interfaces << klass.new(config)
        end
      end
    end

  end
end
