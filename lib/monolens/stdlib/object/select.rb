module Monolens
  module Object
    class Select
      include Lens

      signature(Type::Object, Type::Object, {
        strategy: [Type::Strategy.selection(%w{all first concat}), false],
        separator: [Type::String, false],
        defn: [Type::Any.of(
          Type::Array.of(Type::Name),
          Type::Map.of(Type::Name, Type::Any.of(Type::Array.of(Type::Name), Type::Name))
        ), true],
        on_missing: [Type::Strategy.missing(%w{fail null skip}), false]
      })

      def call(arg, world = {})
        is_hash!(arg, world)

        result = {}
        is_symbol = arg.keys.any?{|k| k.is_a?(Symbol) }
        defn.each_pair do |new_attr, selector|
          new_attr = is_symbol ? new_attr.to_sym : new_attr.to_s

          deeper(world, new_attr) do |w|
            catch (:skip) do
              value = do_select(arg, selector, w)
              result[new_attr] = value
            end
          end
        end
        result
      end

    private

      def do_select(arg, selector, world)
        if selector.is_a?(::Array)
          do_array_select(arg, selector, world)
        else
          do_single_select(arg, selector, world)
        end
      end

      def do_array_select(arg, selector, world)
        case strategy = option(:strategy, :all).to_sym
        when :all
          selector.each_with_object([]) do |old_attr, values|
            catch (:skip) do
              values << do_single_select(arg, old_attr, world)
            end
          end
        when :concat
          values = selector.each_with_object([]) do |old_attr, values|
            catch (:skip) do
              values << do_single_select(arg, old_attr, world)
            end
          end
          values.join(option(:separator, ' '))
        when :first
          selector.each do |old_attr|
            actual, fetched = fetch_on(old_attr, arg)
            return fetched if actual
          end
          on_missing(selector.first, [], world).first
        else
          raise Monolens::Error, "Unexpected strategy `#{strategy}`"
        end
      end

      def do_single_select(arg, selector, world)
        actual, fetched = fetch_on(selector, arg)
        if actual.nil?
          on_missing(selector, [], world).first
        else
          fetched
        end
      end

      def defn
        defn = option(:defn, {})
        defn = defn.each_with_object({}) do |attr, memo|
          memo[attr] = attr
        end if defn.is_a?(::Array)
        defn
      end

      def on_missing(attr, values, world)
        strategy = option(:on_missing, :fail)
        case strategy.to_sym
        when :fail
          fail!("Expected `#{attr}` to be defined", world)
        when :null
          values << nil
        when :skip
          throw :skip
        else
          raise Monolens::Error, "Unexpected on_missing strategy `#{strategy}`"
        end
      end
      private :on_missing
    end
  end
end
