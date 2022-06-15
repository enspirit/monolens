module Monolens
  module Object
    # ```
    # object.allbut: Object -> Object
    #   defn: Array<String> = []
    # ```
    #
    # This lens copies its input object but the keys
    # specified as `defn`.
    #
    # ## Example
    #
    # Applying the following lens:
    #
    # ```yaml
    # object.allbut:
    #   defn: [ 'age', 'hobbies' ]
    # ```
    #
    # to the following input:
    #
    # ```yaml
    # firstname: 'Bernard'
    # company: 'Enspirit'
    # age: 42
    # hobbies: [ 'programming', 'databases' ]
    # ```
    #
    # will return:
    #
    # ```yaml
    # firstname: 'Bernard'
    # company: 'Enspirit'
    # ```
    class Allbut
      include Lens

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
