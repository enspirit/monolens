module Monolens
  module Array
    class Join
      include Lens

      signature(Type::Array, Type::String, {
        separator: [Type::String, false]
      })

      def call(arg, world = {})
        is_array!(arg, world)

        arg.join(option(:separator, ' '))
      end
    end
  end
end
