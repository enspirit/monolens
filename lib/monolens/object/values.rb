module Monolens
  module Object
    class Values
      include Lens

      def initialize(lens)
        super({})
        @lens = Monolens.lens(lens)
      end

      def call(arg, *rest)
        is_hash!(arg)

        dup = arg.dup
        arg.each_pair do |attr, value|
          dup[attr] = @lens.call(value)
        end
        dup
      end
    end
  end
end
