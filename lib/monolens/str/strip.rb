module Monolens
  module Str
    # ```
    # str.strip: String -> String
    # ```
    #
    # This lens removes leading and trailing spaces from its
    # input.
    class Strip
      include Lens

      def call(arg, world = {})
        is_string!(arg, world)

        arg.to_s.strip
      end
    end
  end
end
