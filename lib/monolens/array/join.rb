module Monolens
  module Array
    class Join
      include Lens

      def call(arg, *rest)
        is_array!(arg)

        arg.join(option(:separator, ' '))
      end
    end
  end
end
