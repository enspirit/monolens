module Monolens
  module Array
    # ```
    # array.join: Array -> String
    #   separator: String = ' '
    # ```
    #
    # This lens builds a string by concatenating the
    # values of the input array with a separator.
    class Join
      include Lens

      def call(arg, world = {})
        is_array!(arg, world)

        arg.join(option(:separator, ' '))
      end
    end
  end
end
