module Monolens
  module Str
    class Upcase
      include Lens

      def call(arg, world = {})
        is_string!(arg, world)

        arg.upcase
      end
    end
  end
end
