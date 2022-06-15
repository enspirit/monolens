module Monolens
  module Array
    # ```
    # array.compact: Array -> Array
    # ```
    #
    # This lens returns the input without null values.
    class Compact
      include Lens

      def call(arg, world = {})
        is_array!(arg, world)

        arg.compact
      end
    end
  end
end
