module Monolens
  module Object
    class Transform
      include Lens

      def initialize(options)
        super(options)
        ts = option(:defn, {})
        ts.each_pair do |k,v|
          ts[k] = Monolens.lens(v)
        end
      end

      def call(arg, world = {})
        is_hash!(arg)

        result = arg.dup
        option(:defn, {}).each_pair do |attr, sub_lens|
          actual_attr, fetched = fetch_on(attr, arg)
          if actual_attr
            result[actual_attr] = sub_lens.call(fetched, world)
          else
            on_missing(result, attr)
          end
        end
        result
      end

      def on_missing(result, attr)
        strategy = option(:on_missing, :raise)
        case strategy.to_sym
        when :raise
          raise LensError, "Expected `#{attr}` to be defined"
        when :null
          result[attr] = nil
        when :skip
          nil
        else
          raise Monolens::Error, "Unexpected missing strategy `#{strategy}`"
        end
      end
      private :on_missing
    end
  end
end
