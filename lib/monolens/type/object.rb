module Monolens
  module Type
    class Object
      extend Type::ErrorHandling

      def self.dress(instance, registry, &block)
        fail!("Object expected, got #{instance.class}", &block) unless instance.is_a?(::Hash)

        instance
      end

      def self.===(instance)
        instance.is_a?(::Hash)
      end
    end
  end
end
