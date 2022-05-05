module Monolens
  module Array
    class Map
      include Lens

      def initialize(lens)
        super({})
        @lens = Monolens.lens(lens)
      end

      def call(arg, *rest)
        is_enumerable!(arg)

        arg.map { |a| @lens.call(a) }
      end
    end
  end
end
