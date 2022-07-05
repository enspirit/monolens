module Monolens
  module Type
    class Strategy
      include Type::ErrorHandling

      def initialize(kind, valid)
        @kind = kind
        @valid = valid
      end

      def self.selection(valid)
        new('selection', valid)
      end

      def self.error(valid)
        new('error', valid)
      end

      def self.missing(valid)
        new('missing', valid)
      end

      def dress(arg, registry, &block)
        case arg
        when ::Symbol
          fail!(arg, &block) unless @valid.include?(arg.to_s)
          arg
        when ::String
          fail!(arg, &block) unless @valid.include?(arg)
          arg.to_sym
        when ::Array
          fail!(arg, &block) unless (arg.map(&:to_s) - @valid).empty?
          arg.map(&:to_sym)
        else
          fail!(arg, &block)
        end
      end

      def ===(arg)
        !!dress(arg, nil)
      rescue TypeError
        false
      end

    private

      def fail!(arg, &block)
        super("Invalid #{kind}strategy `#{arg}`", &block)
      end
    end
  end
end
