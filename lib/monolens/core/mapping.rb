module Monolens
  module Core
    class Mapping
      include Lens

      def call(arg, world = {})
        option(:values, {}).fetch(arg) do
          fail!("Unrecognized value `#{arg}`", world) if option(:fail_if_missing)

          option(:default)
        end
      end
    end
  end
end
