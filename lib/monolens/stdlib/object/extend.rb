module Monolens
  module Object
    class Extend
      include Lens

      def initialize(options, registry)
        super(options, registry)
        ts = option(:defn, {})
        ts.each_pair do |k,v|
          ts[k] = lens(v)
        end
      end

      def call(arg, world = {})
        is_hash!(arg, world)

        result = arg.dup
        is_symbol = arg.keys.any?{|k| k.is_a?(Symbol) }
        option(:defn, {}).each_pair do |attr, lens|
          deeper(world, attr) do |w|
            actual = is_symbol ? attr.to_sym : attr.to_s
            begin
              result[actual] = lens.call(arg, w)
            rescue Monolens::LensError => ex
              strategy = option(:on_error, :fail)
              handle_error(strategy, ex, result, actual, world)
            end
          end
        end
        result
      end

      def handle_error(strategy, ex, result, attr, world)
        strategy = strategy.to_sym unless strategy.is_a?(::Array)
        case strategy
        when ::Array
          strategy.each{|s| handle_error(s, ex, result, attr, world) }
        when :fail
          raise
        when :handler
          error_handler!(world).call(ex)
        when :null
          result[attr] = nil
        when :skip
          nil
        else
          raise Monolens::Error, "Unexpected error strategy `#{strategy}`"
        end
      end
      private :handle_error
    end
  end
end
