module Monolens
  module Type
    class Responding
      include Type::ErrorHandling

      def initialize(messages)
        @messages = messages
      end

      def self.to(*messages)
        new(messages)
      end

      def dress(instance, registry, &block)
        fail!("Invalid #{instance}", &block) unless self === instance

        instance
      end

      def ===(instance)
        @messages.all?{|m| instance.respond_to?(m) }
      end
    end
  end
end