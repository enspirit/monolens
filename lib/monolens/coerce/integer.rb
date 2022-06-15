require 'date'

module Monolens
  module Coerce
    # ```
    # coerce.integer: String|Float|Integer -> Integer
    # ```
    #
    # This lens attempts to convert its input to an Integer.
    #
    # When the input is already an Integer, the lens returns
    # it unchanged.
    class Integer
      include Lens

      def call(arg, world = {})
        Integer(arg)
      rescue => ex
        fail!(ex.message, world)
      end
    end
  end
end
