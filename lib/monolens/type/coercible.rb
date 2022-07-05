module Monolens
  module Type
    class Coercible
      def self.to(type)
        # TODO: make me stricter
        ::Object
      end
    end
  end
end
