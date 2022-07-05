module Monolens
  module Object
    class Keys
      include Lens

      signature(Type::Object, Type::Object, {
        lenses: [Type::Lenses, false],
      })

      def call(arg, world = {})
        is_hash!(arg, world)

        lenses = option(:lenses)
        dup = {}
        arg.each_pair do |attr, value|
          deeper(world, attr) do |w|
            lensed = lenses.call(attr, w)
            lensed = lensed.to_sym if lensed && attr.is_a?(Symbol)
            dup[lensed] = value
          end
        end
        dup
      end
    end
  end
end
