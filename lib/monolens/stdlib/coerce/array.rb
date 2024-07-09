module Monolens
  module Coerce
    class Array
      include Lens

      signature(Type::Any, Type::Array)

      def call(arg, world = {})
        Array(arg)
      end
    end
  end
end
