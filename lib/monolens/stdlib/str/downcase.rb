module Monolens
  module Str
    class Downcase
      include Lens

      signature(Type::String, Type::String)

      def call(arg, world = {})
        is_string!(arg, world)

        arg.downcase
      end
    end
  end
end
