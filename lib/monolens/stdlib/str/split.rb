module Monolens
  module Str
    class Split
      include Lens

      def call(arg, world = {})
        is_string!(arg, world)

        sep = option(:separator, ' ')
        sep ? arg.split(sep) : arg.split
      end
    end
  end
end