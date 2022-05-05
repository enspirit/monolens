module Monolens
  module Array
    class Compact
      include Lens

      def call(arg, world = {})
        is_array!(arg)

        arg.compact
      end
    end
  end
end
