module Monolens
  class Macros
    def initialize(macros, registry)
      @macros = macros
      @registry = registry
    end

    def factor_lens(namespace_name, lens_name, options, registry)
      if defn = @macros[lens_name]
        instantiate_macro(defn, options)
      else
        raise Error, "No such lens #{[namespace_name, lens_name].join('.')}"
      end
    end

  private

    def instantiate_macro(defn, options)
      instantiated = Monolens::Core.literal({
        defn: defn,
        jsonpath: {
          root_symbol: '<'
        }
      }, @registry).call(options)
      @registry.lens(instantiated)
    end
  end
end
