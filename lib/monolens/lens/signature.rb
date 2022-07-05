require_relative 'signature/missing'

module Monolens
  module Lens
    class Signature
      MISSING = Missing.new

      def initialize(input, output, options)
        @input = input
        @output = output
        @options = symbolize(options)
      end

      def dress_options(options, registry)
        case options
        when ::Hash
          _dress_options(options.dup, registry)
        when ::Array
          dress_options({lenses: options}, registry)
        when ::String
          dress_options({lenses: [options]}, registry)
        else
          raise Error, "Invalid options `#{options.to_json}`"
        end
      end

    private

      def _dress_options(options, registry)
        options = symbolize(options)
        ks, ls = @options.keys, options.keys

        extra = ls - ks
        fail!("Invalid option `#{extra.first}`") unless extra.empty?

        missing = (ks - ls).select{|name|
          @options[name].last
        }
        fail!("Missing option `#{missing.first}`") unless missing.empty?

        ls.each_with_object({}) do |name,memo|
          type = @options[name].first
          memo[name] = type.dress(options[name], registry) do |err|
            fail!("Invalid option `#{name}`: #{err}")
          end
        end
      end

      def symbolize(options)
        options.each_with_object({}) do |(k,v),memo|
          memo[k.to_sym] = v
        end
      end

      def fail!(message)
        raise TypeError, message
      end
    end
  end
end
