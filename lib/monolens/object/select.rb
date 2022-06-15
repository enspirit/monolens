module Monolens
  module Object
    # ```
    # object.select: Object -> Object
    #   on_missing: fail|null|skip|[...] = fail
    #   strategy: all|first = all
    #   defn: Object<String -> String|[String]> = {}
    # ```
    #
    # This lens creates an output object by selecting some
    # keys of its input object as specified by `defn`. Each
    # pair of the `defn` maps an output key `o` to either
    # a key `i` of the input object, or an array of such keys.
    #
    # When a single key is mapped, `o` will be mapped to
    # `input[i]`. When multiple keys are mapped, the result
    # depends on the specified strategy:
    # - when 'all', `o` will be mapped to an array with all
    #   values fetched.
    # - when 'first', `o` will be mapped to the first non
    #   null value that is found for a given `i`.
    #
    # ## Example
    #
    # Applying the following lens:
    #
    # ```yaml
    # object.select:
    #   defn:
    #     name: ['firstname', 'lastname']
    #     company: company
    #
    # ```
    #
    # to the following input:
    #
    # ```yaml
    # firstname: 'Bernard'
    # lastname: 'Lambeau'
    # company: 'Enspirit SRL'
    # ```
    #
    # will return:
    #
    # ```yaml
    # name: ['Bernard', 'Lambeau']
    # company: 'Enspirit SRL'
    # ```
    class Select
      include Lens

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
        case option(:strategy, :all).to_sym
        when :all
          selector.each_with_object([]) do |old_attr, values|
            catch (:skip) do
              values << do_single_select(arg, old_attr, world)
            end
          end
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
