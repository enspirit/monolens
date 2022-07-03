module Monolens
  module Array
    class Join
      include Lens

      def call(arg, world = {})
        is_array!(arg, world)

        arg.join(option(:separator, ' '))
      end
    end
  end
end
