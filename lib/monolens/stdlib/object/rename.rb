module Monolens
  module Object
    class Rename
      include Lens

      signature(Type::Object, Type::Object, {
        defn: [Type::Map.of(Type::Name, Type::Name), false],
      })

      def call(arg, world = {})
        is_hash!(arg, world)

        dup = arg.dup
        option(:defn, {}).each_pair do |oldname, newname|
          actual_name, value = fetch_on(oldname, arg)
          newname = actual_name.is_a?(Symbol) ? newname.to_sym : newname.to_s
          dup.delete(actual_name)
          dup[newname] = value
        end
        dup
      end
    end
  end
end
