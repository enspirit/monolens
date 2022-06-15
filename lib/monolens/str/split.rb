module Monolens
  module Str
    # ```
    # str.split: String -> Array<String>
    #   separator: String = ' '
    # ```
    #
    # This lens splits its input string to an array of
    # strings using a separator.
    class Split
      include Lens

      def call(arg, world = {})
        is_string!(arg, world)

        sep = option(:separator, ' ')
        sep ? arg.split(sep) : arg.split
      end
    end
  end
end
