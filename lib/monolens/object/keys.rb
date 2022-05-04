module Monolens
  module Object
    class Keys
      include Lens

      def initialize(lens)
        super({})
        @lens = Monolens.lens(lens)
      end

      def call(arg, *rest)
        is_hash!(arg)

        dup = {}
        arg.each_pair do |attr, value|
          lensed = @lens.call(attr.to_s)
          lensed = lensed.to_sym if lensed && attr.is_a?(Symbol)
          dup[lensed] = value
        end
        dup
      end
    end
  end
end
