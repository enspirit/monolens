module Monolens
  module Utils
    class Path
      INTERPOLATE_RX = %r{
        \$
        (
          (\.([a-zA-Z0-9.-_\[\]])+)
        |
          (\([^)]+\))
        )        
      }x.freeze

      DEFAULT_OPTIONS = {
        semantics: 'dig'
      }

      def initialize(path, options = {})
        @path = path
        @options = options
      end

      def self.one(path, input, options = {})
        options = DEFAULT_OPTIONS.merge(options)

        case (semantics = options[:semantics])
        when 'dig'
          Dig.new(path, options).one(input)
        else
          raise ArgumentError, "Unknown jsonpath `#{semantics}`"
        end
      end

      def self.interpolate(str, input, options = {})
        str.gsub(INTERPOLATE_RX) do |path|
          one(path, input, options)
        end
      end


      def one(input)
        raise NotImplementedError
      end

    private

      def use_symbols?(input)
        case input
        when ::Hash
          input.keys.any?{|s| s.is_a?(Symbol) }
        when ::Array
          input.any?{|x| use_symbols?(x) }
        else
          false
        end
      end
    end
  end
end
require_relative 'path/dig'