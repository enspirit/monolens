module Monolens
  module Type
    class Any
      include Type::ErrorHandling

      def initialize(candidates)
        @candidates = candidates
      end

      def self.of(*candidates)
        Any.new(candidates)
      end

      def self.dress(instance, registry)
        instance
      end

      def self.===(instance)
        true
      end

      def ===(instance)
        @candidates.any?{|c| c === instance }
      end

      def dress(instance, registry, &block)
        first_error = nil
        @candidates.each do |candidate|
          begin
            return candidate.dress(instance, registry, &block)
          rescue TypeError => ex
            first_error ||= ex
          end
        end
        fail!(first_error.message, &block)
      end
    end
  end
end
