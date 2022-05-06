module Monolens
  module Object
    class Values
      include Lens

      def call(arg, world = {})
        is_hash!(arg, world)

        lenses = option(:lenses)
        result = arg.dup
        arg.each_pair do |attr, value|
          deeper(world, attr) do |w|
            begin
              result[attr] = lenses.call(value, w)
            rescue Monolens::LensError => ex
              strategy = option(:on_error, :fail)
              handle_error(strategy, ex, result, attr, value, world)
            end
          end
        end
        result
      end

      def handle_error(strategy, ex, result, attr, value, world)
        strategy = strategy.to_sym unless strategy.is_a?(::Array)
        case strategy
        when ::Array
          strategy.each{|s| handle_error(s, ex, result, attr, value, world) }
        when :handler
          error_handler!(world).call(ex)
        when :fail
          raise
        when :null
          result[attr] = nil
        when :skip
          result.delete(attr)
        when :keep
          result[attr] = value
        else
          raise Monolens::Error, "Unexpected error strategy `#{strategy}`"
        end
      end
      private :handle_error
    end
  end
end
