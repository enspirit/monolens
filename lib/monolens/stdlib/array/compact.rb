module Monolens
  module Array
    class Compact
      include Lens

      signature(Type::Array, Type::String)

      def call(arg, world = {})
        is_array!(arg, world)

        arg.compact
      end
    end
  end
end
