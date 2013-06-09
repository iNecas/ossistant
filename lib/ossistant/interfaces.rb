module Ossistant
  module Interfaces

    # The inteface should inherit from this class
    class Base

      attr_reader :name

      def self.inherited(klass)
        self.types << klass
      end

      # @return [Array<Interfaces::Base>] interfaces types available
      def self.types
        @types ||= []
      end

      attr_accessor :bus

      def initialize(config)
        @name = config['name']
        @bus = Ossistant.bus
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

    # Keeps the configuration of all the interfaces. Layer between the
    # interfaces and their stored configuration.
    class Config

      attr_reader :interfaces_config

      # @param [Hash] interfaces_config
      def initialize(interfaces_config)
        @interfaces_config = interfaces_config
        @interfaces = {}
      end

      # load the interfaces from configuration
      def load
        Interfaces::Base.types.each do |klass|
          all_of_type(klass.type_name).each do |config|
            interface = klass.new(config)
            @interfaces[interface.name] = interface
          end
        end
      end

      def find(name)
        @interfaces[name.to_s]
      end

      private

      def all_of_type(type)
        @interfaces_config.find_all do |name, config|
          config['type'] == type
        end.map do |(name, config)|
          config.merge('name' => name)
        end
      end

    end

  end
end
