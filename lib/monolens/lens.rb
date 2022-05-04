module Monolens
  module Lens
    def initialize(options = {})
      @options = options.each_with_object({}){|(k,v),memo|
        memo[k.to_sym] = v
      }
    end
    attr_reader :options

    def is_string!(arg)
      return if arg.is_a?(String)

      raise Monolens::Error, "String expected, got #{arg.class}"
    end

    def is_hash!(arg)
      return if arg.is_a?(Hash)

      raise Monolens::Error, "Hash expected, got #{arg.class}"
    end
  end
end
