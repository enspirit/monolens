module Monolens
  module Array
    # ```
    # array.map: Array -> Array
    #   on_error: fail|handler|keep|null|skip|[...] = fail
    #   lenses: Lens
    # ```
    #
    # This lens applies a sublens to every member of the input
    # value and collects the result as a new array.
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
        is_enumerable!(arg, world)

        result = []
        arg.each_with_index do |member, i|
          deeper(world, i) do |w|
            begin
              result << @lenses.call(member, w)
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
