module Monolens
  module Str
    # ```
    # str.upcase: String -> String
    # ```
    #
    # This lens converts its input to the same string but
    # in upper case.
    class Upcase
      include Lens

      def call(arg, world = {})
        is_string!(arg, world)

        arg.upcase
      end
    end
  end
end
