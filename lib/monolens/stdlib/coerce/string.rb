require 'date'

module Monolens
  module Coerce
    class String
      include Lens

      signature(Type::Any, Type::String)

      def call(arg, world = {})
        arg.to_s
      end
    end
  end
end
