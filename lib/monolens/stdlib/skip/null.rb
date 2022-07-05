module Monolens
  module Skip
    class Null
      include Lens

      signature(Type::Any, Type::Any)

      def call(arg, world = {})
        throw :skip if arg.nil?

        arg
      end
    end
  end
end
