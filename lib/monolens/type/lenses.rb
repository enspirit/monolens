module Monolens
  module Type
    class Lenses
      extend Type::ErrorHandling

      def self.===(arg)
        arg.is_a?(Lens)
      end

      def self.dress(value, registry, &block)
        registry.lens(value)
      rescue TypeError => ex
        fail!(ex.message, &block)
      end
    end
  end
end
