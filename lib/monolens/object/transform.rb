module Monolens
  module Object
    class Transform
      include Lens

      def initialize(transformation)
        super({})
        @transformation = transformation.each_with_object({}){|(attr,lens),memo|
          memo[attr.to_sym] = Monolens.lens(lens)
        }
      end

      def call(arg, *rest)
        is_hash!(arg)

        dup = arg.dup
        @transformation.each_pair do |attr, sub_lens|
          actual_attr, fetched = fetch_on(attr, dup)
          dup[actual_attr] = sub_lens.call(fetched)
        end
        dup
      end
    end
  end
end
