module Monolens
  module Lens
    class Location
      def initialize(parts = [])
        @parts = parts
      end

      def deeper(part)
        yield Location.new(@parts + [part])
      end

      def to_a
        @parts.dup
      end
    end
  end
end
