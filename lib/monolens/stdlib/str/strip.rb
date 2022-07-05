module Monolens
  module Str
    class Strip
      include Lens

      signature(Type::String, Type::String)

      def call(arg, world = {})
        is_string!(arg, world)

        arg.to_s.strip
      end
    end
  end
end
