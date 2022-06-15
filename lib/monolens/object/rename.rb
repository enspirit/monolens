module Monolens
  module Object
    # ```
    # object.rename: Object -> Object
    #   defn: Object<String -> String> = {}
    # ```
    #
    # This lens copies its input object but renames some keys
    # as specified by `defn`.
    #
    # ## Example
    #
    # Applying the following lens:
    #
    # ```yaml
    # object.rename:
    #   defn: { firstname: name }
    # ```
    #
    # to the following input:
    #
    # ```yaml
    # firstname: 'Bernard'
    # company: 'Enspirit'
    # ```
    #
    # will return:
    #
    # ```yaml
    # name: 'Bernard'
    # company: 'Enspirit'
    # ```
    class Rename
      include Lens

      def call(arg, world = {})
        is_hash!(arg, world)

        dup = arg.dup
        option(:defn).each_pair do |oldname, newname|
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
