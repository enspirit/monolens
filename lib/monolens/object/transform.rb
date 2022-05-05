module Monolens
  module Object
    class Transform
      include Lens

      def initialize(options)
        super(options)
        ts = option(:defn, {})
        ts.each_pair do |k,v|
          ts[k] = Monolens.lens(v)
        end
      end

      def call(arg, world = {})
        is_hash!(arg)

        dup = arg.dup
        option(:defn, {}).each_pair do |attr, sub_lens|
          actual_attr, fetched = fetch_on(attr, dup)
          dup[actual_attr] = sub_lens.call(fetched, world)
        end
        dup
      end
    end
  end
end
