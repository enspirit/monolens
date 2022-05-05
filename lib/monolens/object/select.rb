module Monolens
  module Object
    class Select
      include Lens

      def call(arg, *rest)
        is_hash!(arg)

        result = {}
        option(:defn, {}).each_pair do |new_attr, selector|
          is_array = selector.is_a?(::Array)
          is_symbol = false
          values = Array(selector).map do |old_attr|
            actual, fetched = fetch_on(old_attr, arg)
            is_symbol ||= actual.is_a?(Symbol)
            fetched
          end
          new_attr = is_symbol ? new_attr.to_sym : new_attr.to_s
          result[new_attr] = is_array ? values : values.first
        end
        result
      end
    end
  end
end
