module Monolens
  module Object
    class Merge
      include Lens

      signature(Type::Object, Type::Object, {
        priority: [Type::Strategy.priority(%w{input defn}), false],
        deep: [Type::Boolean, false],
        defn: [Type::Object, true]
      })

      def call(input, world = {})
        is_hash!(input, world)

        v1, v2 = input, option(:defn, {})
        if deep?
          deep_merge(v1, v2, world, priority_at_input?)
        else
          normal_merge(v1, v2, world, priority_at_input?)
        end
      end

    private

      def normal_merge(v1, v2, world, priority_at_input)
        is_hash!(v1, world)
        is_hash!(v2, world)

        v1.merge(v2) do |k, v11, v22|
          priority_at_input? ? v11 : v22
        end
      end

      def deep_merge(v1, v2, world, priority_at_input)
        case v1
        when ::Hash
          is_hash!(v2, world)

          v1.merge(v2) do |k, v11, v22|
            deep_merge(v11, v22, world, priority_at_input)
          end
        else
          priority_at_input? ? v1 : v2
        end
      end

      def deep?
        option(:deep, false) == true
      end

      def priority_at_input?
        @pati ||= (option(:priority, 'defn').to_s == 'input')
      end
    end
  end
end
