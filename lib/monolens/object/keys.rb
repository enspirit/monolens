module Monolens
  module Object
    # ```
    # object.keys: Object -> Object
    #   lenses: Lens
    # ```
    #
    # This lens transforms all keys of its input object by
    # using the lenses provided.
    #
    # ## Example
    #
    # Applying the following lens:
    #
    # ```yaml
    # object.keys:
    #   lenses:
    #   - str.upcase
    #
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
    # FIRSTNAME: 'Bernard'
    # COMPANY: 'Enspirit'
    # ```
    class Keys
      include Lens

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
