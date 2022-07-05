module Monolens
  module Type
    class Callback
      extend Type::ErrorHandling

      def self.dress(instance, registry, &block)
        fail!("Invalid #{instance}", &block) unless self === instance

        instance
      end

      def self.===(instance)
        instance.respond_to?(:call)
      end
    end
  end
end