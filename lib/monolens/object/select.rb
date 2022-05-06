module Monolens
  module Object
    class Select
      include Lens

      def call(arg, world = {})
        is_hash!(arg, world)

        result = {}
        is_symbol = arg.keys.any?{|k| k.is_a?(Symbol) }
        option(:defn, {}).each_pair do |new_attr, selector|
          deeper(world, new_attr) do |w|
            is_array = selector.is_a?(::Array)
            values = []
            Array(selector).each do |old_attr|
              actual, fetched = fetch_on(old_attr, arg)
              if actual.nil?
                on_missing(old_attr, values, w)
              else
                values << fetched
              end
            end
            new_attr = is_symbol ? new_attr.to_sym : new_attr.to_s
            unless values.empty?
              result[new_attr] = is_array ? values : values.first
            end
          end
        end
        result
      end

      def on_missing(attr, values, world)
        strategy = option(:on_missing, :fail)
        case strategy.to_sym
        when :fail
          fail!("Expected `#{attr}` to be defined", world)
        when :null
          values << nil
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
