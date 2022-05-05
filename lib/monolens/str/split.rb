module Monolens
  module Str
    class Split
      include Lens

      def call(arg, *rest)
        is_string!(arg)

        sep = option(:separator)
        sep ? arg.split(sep) : arg.split
      end
    end
  end
end
