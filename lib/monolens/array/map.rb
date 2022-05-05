module Monolens
  module Array
    class Map
      include Lens

      def initialize(arg)
        options, lenses = case arg
        when ::Hash
          opts = arg.dup; opts.delete(:lenses)
          _, ls = fetch_on(:lenses, arg)
          raise ArgumentError, 'Lenses are required' if ls.nil?
          [ opts, ls ]
        else
          [{}, arg]
        end
        super(options)
        @lenses = Monolens.lens(lenses)
      end

      def call(arg, world = {})
        is_enumerable!(arg)

        result = []
        arg.each do |a|
          begin
            result << @lenses.call(a, world)
          rescue Monolens::LensError => ex
            strategy = option(:on_error, :raise)
            handle_error(strategy, ex, result, world)
          end
        end
        result
      end

      def handle_error(strategy, ex, result, world)
        strategy = strategy.to_sym unless strategy.is_a?(::Array)
        case strategy
        when ::Array
          strategy.each{|s| handle_error(s, ex, result, world) }
        when :handler
          error_handler!(world).call(ex)
        when :raise
          raise
        when :null
          result << nil
        when :skip
          nil
        end
      end
      private :handle_error
    end
  end
end
