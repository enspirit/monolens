module Monolens
  module Skip
    class Null
      include Lens

      def call(arg, *rest)
        throw :skip if arg.nil?

        arg
      end
    end
  end
end
