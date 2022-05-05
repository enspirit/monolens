module Monolens
  module Str
    class Downcase
      include Lens

      def call(arg, world = {})
        is_string!(arg)

        arg.downcase
      end
    end
  end
end
