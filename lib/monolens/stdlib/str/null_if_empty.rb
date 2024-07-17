module Monolens
  module Str
    class NullIfEmpty
      include Lens

      signature(Type::String, Type::String)

      def call(arg, world = {})
        is_string!(arg, world)

        arg.to_s.strip.empty? ? nil : arg
      end
    end
  end
end
