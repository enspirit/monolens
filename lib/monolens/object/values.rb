module Monolens
  module Object
    class Values
      include Lens

      def call(arg, world = {})
        is_hash!(arg)

        lenses = option(:lenses)
        result = arg.dup
        arg.each_pair do |attr, value|
          begin
            result[attr] = lenses.call(value, world)
          rescue Monolens::LensError => ex
            strategy = option(:on_error, :fail)
            handle_error(strategy, ex, result, attr, world)
          end
        end
        result
      end

      def handle_error(strategy, ex, result, attr, world)
        strategy = strategy.to_sym unless strategy.is_a?(::Array)
        case strategy
        when ::Array
          strategy.each{|s| handle_error(s, ex, result, attr, world) }
        when :handler
          error_handler!(world).call(ex)
        when :fail
          raise
        when :null
          result[attr] = nil
        when :skip
          result.delete(attr)
        else
          raise Monolens::Error, "Unexpected error strategy `#{strategy}`"
        end
      end
      private :handle_error
    end
  end
end
