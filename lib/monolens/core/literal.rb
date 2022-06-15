module Monolens
  module Core
    # ```
    # core.literal: Any -> Any, {
    #   defn: Any = null
    # }
    # ```
    #
    # This lens returns the value taken as `defn`.
    class Literal
      include Lens

      def call(arg, world = {})
        option(:defn)
      end
    end
  end
end
