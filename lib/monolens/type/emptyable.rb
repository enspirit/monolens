module Monolens
  module Type
    class Emptyable
      def self.===(instance)
        instance.respond_to?(:empty)
      end
    end
  end
end