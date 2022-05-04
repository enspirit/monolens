module Monolens
  module Lens
    class Transform
      include Lens

      def initialize(parts)
        @parts = parts
      end

      def self.hash(hash)
        new(hash[:transform])
      end

      def call(arg, *rest)
        is_hash!(arg)

        dup = arg.dup
        @parts.each_pair do |attr, sub_lens|
          dup[attr] = sub_lens.call(arg[attr])
        end
        dup
      end

      def to_hash
        { transform: @parts }
      end
    end
  end
end
