module Monolens
  module Lens
    class Upcase
      include Lens

      def call(arg, *rest)
        is_string!(arg)

        arg.upcase
      end
    end
  end
end
