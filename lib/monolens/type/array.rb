module Monolens
  module Type
    class Array
      include Type::ErrorHandling

      def initialize(item_type)
        @item_type = item_type
      end

      def self.of(item_type)
        Array.new(item_type)
      end

      def dress(instance, registry, &block)
        fail!("Array expected, got #{instance.class}", &block) unless instance.is_a?(::Array)

        instance.map{|item| @item_type.dress(item, registry, &block) }
      end

      def ===(instance)
        instance.is_a?(::Enumerable) && instance.all?{|item|
          @item_type === item
        }
      end
    end
  end
end