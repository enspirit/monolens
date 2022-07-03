require 'date'

module Monolens
  module Coerce
    class Integer
      include Lens

      def call(arg, world = {})
        Integer(arg)
      rescue => ex
        fail!(ex.message, world)
      rescue ArgumentError => ex
        fail!(ex.message, world)
      end
    end
  end
end
