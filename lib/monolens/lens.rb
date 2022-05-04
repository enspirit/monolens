module Monolens
  module Lens
    def self.leaf(arg)
      name, params = case arg
      when String then [arg, nil]
      when Hash   then [arg.keys.first, arg.values.first]
      else
        raise ArgumentError, "Unknown lens #{arg}"
      end
      case name.to_s
      when 'str.strip' then Str::Strip.new
      when 'str.upcase' then Str::Upcase.new
      when 'str.downcase' then Str::Downcase.new
      when 'coerce.date' then Coerce::Date.new(params)
      else
        raise ArgumentError, "Unknown lens #{arg}"
      end
    end

    def initialize(options = {})
      @options = options
    end
    attr_reader :options

    def is_string!(arg)
      return if arg.is_a?(String)

      raise Monolens::Error "String expected, got #{arg.class}"
    end

    def is_hash!(arg)
      return if arg.is_a?(Hash)

      raise Monolens::Error "Hash expected, got #{arg.class}"
    end

    def to_leaf
      raise NotImplementedError
    end
  end
end
