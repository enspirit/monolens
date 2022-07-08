module Monolens
  module Type
    class Boolean
      include Type::ErrorHandling

      def self.dress(instance, registry, &block)
        fail!("Invalid Boolean `#{instance}`") unless self === instance

        instance
      end

      def self.===(instance)
        instance == true || instance == false
      end
    end
  end
end
