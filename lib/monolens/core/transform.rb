module Monolens
  module Core
    class Transform
      include Lens

      def initialize(options)
        super(options.each_with_object({}){|(attr,lens),memo|
          memo[attr] = Monolens.lens(lens)
        })
      end

      def call(arg, *rest)
        is_hash!(arg)

        dup = arg.dup
        options.each_pair do |attr, sub_lens|
          dup[attr] = sub_lens.call(arg[attr])
        end
        dup
      end
    end
  end
end
