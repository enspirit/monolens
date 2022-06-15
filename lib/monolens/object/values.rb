module Monolens
  module Object
    # ```
    # object.values: Object -> Object
    #   on_error: fail|handler|keep|null|skip|[...] = fail
    #   lenses: Lens
    # ```
    #
    # This lens transforms all values of its input object by
    # using the lenses provided.
    #
    # ## Example
    #
    # Applying the following lens:
    #
    # ```yaml
    # object.values:
    #   lenses:
    #   - str.upcase
    #
    # ```
    #
    # to the following input:
    #
    # ```yaml
    # firstname: 'Bernard'
    # company: 'Enspirit'
    # ```
    #
    # will return:
    #
    # ```yaml
    # firstname: 'BERNARD'
    # company: 'ENSPIRIT'
    # ```
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
        when :fail
          raise
        when :handler
          error_handler!(world).call(ex)
        when :keep
          result[attr] = value
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
