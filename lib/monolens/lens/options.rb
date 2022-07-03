module Monolens
  module Lens
    class Options
      include FetchSupport

      def initialize(options, registry)
        raise ArgumentError if options.nil?
        raise ArgumentError if registry.nil?

        compile(options, registry)
      end
      attr_reader :options, :registry
      private :options, :registry

      NO_DEFAULT = Object.new.freeze

      def lens(arg)
        registry.lens(arg)
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

    private

      def compile(options, registry)
        @options = options.is_a?(Hash) ? options.dup : { lenses: options }
        @registry = registry

        actual, lenses = fetch_on(:lenses, @options)
        @options[actual] = lens(lenses) if actual && lenses
      end

    end
  end
end
