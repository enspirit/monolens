module Monolens
  module Str
    class Upcase
      include Lens

      signature(Type::String, Type::String)

      def call(arg, world = {})
        is_string!(arg, world)

        arg.upcase
      end
    end
  end
end
