module Monolens
  module Type
    class Map
      include Type::ErrorHandling

      def initialize(key_type, value_type)
        @key_type = key_type
        @value_type = value_type
      end

      def self.of(key_type, value_type)
        Map.new(key_type, value_type)
      end

      def dress(value, registry, &block)
        fail!("Map expected, got #{value.class}", &block) unless value.is_a?(::Hash)

        value.each_with_object({}) do |(k,v), memo|
          memo[@key_type.dress(k, registry, &block)] = @value_type.dress(v, registry, &block)
        end
      end

      def ===(instance)
        instance.is_a?(::Hash) && instance.all?{|(k,v)|
          @key_type === k && @value_type === v
        }
      end
    end
  end
end