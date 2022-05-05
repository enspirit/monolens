module Monolens
  module Core
    class Mapping
      include Lens

      def call(arg, *rest)
        option(:values, {}).fetch(arg) do
          raise LensError if option(:fail_if_missing)

          option(:default)
        end
      end
    end
  end
end
