module Monolens
  module Lens
    def self.leaf(name)
      case name.to_s
      when 'strip' then Strip.new
      when 'upcase' then Upcase.new
      when 'downcase' then Downcase.new
      else
        raise ArgumentError, "Unknown lens #{name}"
      end
    end

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
