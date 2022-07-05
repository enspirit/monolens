module Monolens
  module Core
    class Literal
      include Lens

      signature(Type::Any, Type::Any, {
        defn: [Type::Any, true],
        jsonpath: [Type::Object, false]
      })

      def initialize(options, registry)
        super(options, registry)
        @root_symbol = extract_jsonpath_root_symbol
        @one_rx = Jsonpath.one_detect_rx(@root_symbol)
        @interpolate_rx = Jsonpath.interpolate_detect_rx(@root_symbol)
      end

      def call(arg, world = {})
        instantiate(option(:defn), arg, world)
      end

    private

      def instantiate(obj, input, world)
        case obj
        when ::Array
          obj.map {|item|
            instantiate(item, input, world)
          }
        when ::Hash
          obj.each_with_object({}){|(k,v),memo|
            memo[k] = instantiate(v, input, world)
          }
        when @one_rx
          Jsonpath.one(obj, input, jsonpath_options(input))
        when @interpolate_rx
          Jsonpath.interpolate(obj, input, jsonpath_options(input))
        else
          obj
        end
      end

      def jsonpath_options(input)
        {
          use_symbols: use_symbols?(input),
          root_symbol: @root_symbol
        }
      end

      def extract_jsonpath_root_symbol
        opts = option(:jsonpath, {})
        _, symbol = fetch_on(:root_symbol, opts, '$')
        symbol
      end

      def use_symbols?(input)
        case input
        when ::Hash
          input.keys.any?{|s| s.is_a?(Symbol) }
        when ::Array
          input.any?{|x| use_symbols?(x) }
        else
          false
        end
      end
    end
  end
end
