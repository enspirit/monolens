module Monolens
  module Type
    class Diggable
      def self.===(instance)
        instance.respond_to?(:dig)
      end
    end
  end
end
