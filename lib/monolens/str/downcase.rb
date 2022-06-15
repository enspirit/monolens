module Monolens
  module Str
    # ```
    # str.downcase: String -> String
    # ```
    #
    # This lens converts its input to the same string but
    # in lower case.
    class Downcase
      include Lens

      def call(arg, world = {})
        is_string!(arg, world)

        arg.downcase
      end
    end
  end
end
