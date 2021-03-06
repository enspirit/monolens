module Monolens
  module Array
    class Map
      include Lens

      signature(Type::Array, Type::Array, {
        on_error: [Type::Strategy.error(%w{handler keep fail null skip}), false],
        lenses: [Type::Lenses, true]
      })

      def call(arg, world = {})
        is_array!(arg, world)

        lenses = option(:lenses)
        result = []
        arg.each_with_index do |member, i|
          deeper(world, i) do |w|
            begin
              result << lenses.call(member, w)
            rescue Monolens::LensError => ex
              strategy = option(:on_error, :fail)
              handle_error(strategy, member, ex, result, world)
            end
          end
        end
        result
      end

      def handle_error(strategy, member, ex, result, world)
        strategy = strategy.to_sym unless strategy.is_a?(::Array)
        case strategy
        when ::Array
          strategy.each{|s| handle_error(s, member, ex, result, world) }
        when :handler
          error_handler!(world).call(ex)
        when :keep
          result << member
        when :fail
          raise
        when :null
          result << nil
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
