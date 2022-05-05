module Monolens
  module Object
    class Select
      include Lens

      def call(arg, world = {})
        is_hash!(arg)

        result = {}
        is_symbol = arg.keys.any?{|k| k.is_a?(Symbol) }
        option(:defn, {}).each_pair do |new_attr, selector|
          is_array = selector.is_a?(::Array)
          values = []
          Array(selector).each do |old_attr|
            actual, fetched = fetch_on(old_attr, arg)
            if actual.nil?
              on_missing(old_attr, values)
            else
              values << fetched
            end
          end
          new_attr = is_symbol ? new_attr.to_sym : new_attr.to_s
          unless values.empty?
            result[new_attr] = is_array ? values : values.first
          end
        end
        result
      end

      def on_missing(attr, values)
        strategy = option(:on_missing, :fail)
        case strategy.to_sym
        when :fail
          raise LensError, "Expected `#{attr}` to be defined"
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
