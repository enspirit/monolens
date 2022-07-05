
module Monolens
  module Type
    class Integer
      extend Type::ErrorHandling

      def self.===(instance)
        instance.is_a?(::Integer)
      end

      def self.dress(instance, registry, &block)
        fail!("Invalid integer #{instance}", &block) unless self === instance

        instance
      end
    end
  end
end