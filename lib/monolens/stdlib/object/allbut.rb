module Monolens
  module Object
    class Allbut
      include Lens

      signature(Type::Object, Type::Object, {
        defn: [Type::Array.of(Type::Name), false]
      })

      def call(arg, world = {})
        is_hash!(arg, world)

        allbut = option(:defn, [])
        arg.delete_if{|k|
          allbut.include?(k) || \
          allbut.include?(k.to_s) || \
          allbut.include?(k.to_sym)
        }
      end
    end
  end
end
