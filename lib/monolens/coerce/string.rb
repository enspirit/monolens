require 'date'

module Monolens
  module Coerce
    # ```
    # coerce.string: Any -> String
    # ```
    #
    # This lens convert its input to a String.
    #
    # Note that this lens always succeeds, as it simply calls
    # Ruby's `#to_s` on the input.
    class String
      include Lens

      def call(arg, world = {})
        arg.to_s
      end
    end
  end
end
