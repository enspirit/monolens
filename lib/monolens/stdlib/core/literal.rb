module Monolens
  module Core
    class Literal
      include Lens

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
        when /^\$\.[^\s]+$/
          Utils::Path.one(obj, input, world[:jsonpath] || {})
        when /\$[.(]/
          Utils::Path.interpolate(obj, input, world[:jsonpath] || {})
        else
          obj
        end
      end
    end
  end
end
