module Monolens
  module Lens
    def self.leaf(name)
      case name.to_s
      when 'strip' then Strip.new
      when 'upcase' then Upcase.new
      else
        raise ArgumentError, "Unknown lens #{name}"
      end
    end

    def string!(arg)
      return if arg.is_a?(String)

      raise Monolens::Error "String expected, got #{arg.class}"
    end

    def to_leaf
      raise NotImplementedError
    end
  end
end
