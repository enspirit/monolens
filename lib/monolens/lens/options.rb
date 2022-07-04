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

      def lens(arg, registry = @registry)
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
        @registry = compile_macros(@options, registry)
        actual, lenses = fetch_on(:lenses, @options)
        @options[actual] = lens(lenses) if actual && lenses
      end

      def compile_macros(options, registry)
        _, macros = fetch_on(:macros, @options)
        return registry unless macros

        registry.fork('self').tap{|r|
          r.define_namespace 'self', Macros.new(macros, registry)
        }
      end

    end
  end
end
