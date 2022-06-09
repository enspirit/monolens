module Monolens
  module Core
    class Literal
      include Lens

      def call(arg, world = {})
        option(:defn)
      end
    end
  end
end
