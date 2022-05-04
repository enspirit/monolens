module Monolens
  module Lens
    class Downcase
      include Lens

      def call(arg, *rest)
        is_string!(arg)

        arg.downcase
      end
    end
  end
end
