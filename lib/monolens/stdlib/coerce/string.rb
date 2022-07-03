require 'date'

module Monolens
  module Coerce
    class String
      include Lens

      def call(arg, world = {})
        arg.to_s
      end
    end
  end
end
