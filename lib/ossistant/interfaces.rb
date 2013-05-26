module Ossistant
  class Interfaces

    class Base

      attr_reader :name

      def self.inherited(klass)
        Ossistant.config.interfaces.types << klass
      end

      def initialize(config)
        @name = config['name']
      end

      # Is the event from web request for this interface authentic?
      def authentic?(request)
        return false # needs to be implemented per interface
      end

      # Helper method for constant time comparison
      def constant_time_equal?(str1, str2)
        a, b = str1.to_s.upcase, str2.to_s.upcase
        check = a.bytesize ^ b.bytesize
        a.bytes.zip(b.bytes) { |x, y| check |= x ^ y.to_i }
        check == 0
      end

    end

    attr_reader :interfaces, :types

    # @param [Ossistant::Config]
    def initialize(config)
      @config = config
      @types = []
      @interfaces = {}
    end

    def load
      @types.each do |klass|
        @config.interface_configs(klass.type_name).each do |config|
          interface = klass.new(config)
          @interfaces[interface.name] = interface
        end
      end
    end

    def find(name)
      @interfaces[name.to_s]
    end

  end
end
