
module Monolens
  module Type
    class Symbol
      extend Type::ErrorHandling

      def self.===(instance)
        instance.is_a?(::Symbol)
      end

      def self.dress(instance, registry, &block)
        unless instance.is_a?(::String) or instance.is_a?(::Symbol)
          fail!("Invalid symbol #{instance}", &block)
        end

        instance.to_sym
      end
    end
  end
end