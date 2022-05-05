module Monolens
  module Core
    class Mapping
      include Lens

      def call(arg, world = {})
        option(:values, {}).fetch(arg) do
          raise LensError, "Unrecognized value `#{arg}`" if option(:fail_if_missing)

          option(:default)
        end
      end
    end
  end
end
