module Monolens
  module Lens
    class Options
      include FetchSupport

      def initialize(options)
        @options = case options
        when Hash
          options.dup
        else
          { lenses: options }
        end
        actual, lenses = fetch_on(:lenses, @options)
        @options[actual] = lens(lenses) if actual && lenses
        @options.freeze
      end
      attr_reader :options
      private :options

      NO_DEFAULT = Object.new.freeze

      def lens(arg)
        Monolens.lens(arg)
      end

      def fetch(key, default = NO_DEFAULT, on = @options)
        if on.key?(key)
          on[key]
        elsif on.key?(s = key.to_s)
          on[s]
        elsif on.key?(sym = key.to_sym)
          on[sym]
        elsif default != NO_DEFAULT
          default
        else
          raise Error, "Missing option #{key}"
        end
      end

      def to_h
        @options.dup
      end
    end
  end
end
