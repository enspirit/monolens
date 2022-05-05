module Monolens
  module Lens
    def initialize(options = {})
      @options = options.each_with_object({}){|(k,v),memo|
        memo[k.to_sym] = v
      }
    end
    attr_reader :options

    def fetch_on(attr, arg)
      if arg.key?(attr)
        [ attr, arg[attr] ]
      elsif arg.key?(attr_s = attr.to_s)
        [ attr_s, arg[attr_s] ]
      elsif arg.key?(attr_sym = attr.to_sym)
        [ attr_sym, arg[attr_sym] ]
      else
        [ attr, nil ]
      end
    end

    def is_string!(arg)
      return if arg.is_a?(::String)

      raise Monolens::Error, "String expected, got #{arg.class}"
    end

    def is_hash!(arg)
      return if arg.is_a?(::Hash)

      raise Monolens::Error, "Hash expected, got #{arg.class}"
    end

    def is_enumerable!(arg)
      return if arg.is_a?(::Enumerable)

      raise Monolens::Error, "Enumerable expected, got #{arg.class}"
    end

    def is_array!(arg)
      return if arg.is_a?(::Array)

      raise Monolens::Error, "Array expected, got #{arg.class}"
    end
  end
end
