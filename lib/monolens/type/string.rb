
module Monolens
  module Type
    class String
      extend Type::ErrorHandling

      def self.===(instance)
        instance.is_a?(::String)
      end

      def self.dress(instance, registry, &block)
        fail!("Invalid string #{instance}", &block) unless self === instance

        instance
      end
    end
  end
end