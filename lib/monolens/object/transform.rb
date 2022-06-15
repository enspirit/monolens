module Monolens
  module Object
    # ```
    # object.transform: Object -> Object
    #   on_missing: fail|null|skip|[...] = fail
    #   defn: Object<String -> Lens> = {}
    # ```
    #
    # This lens transforms its input object as specified in
    # `defn`. Each pair of the `defn` maps a key to a lens
    # that will be applied to the corresponding value of the
    # input object.
    #
    # ## Example
    #
    # Applying the following lens:
    #
    # ```yaml
    # object.transform:
    #   defn:
    #     firstname:
    #     - str.upcase
    #     company:
    #     - str.split: { separator: ' ' }
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
    # firstname: 'BERNARD'
    # lastname: 'Lambeau'
    # company: ['Enspirit', 'SRL']
    # ```
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
        is_hash!(arg, world)

        result = arg.dup
        option(:defn, {}).each_pair do |attr, sub_lens|
          deeper(world, attr) do |w|
            actual_attr, fetched = fetch_on(attr, arg)
            if actual_attr
              result[actual_attr] = sub_lens.call(fetched, w)
            else
              on_missing(result, attr, world)
            end
          end
        end
        result
      end

      def on_missing(result, attr, world)
        strategy = option(:on_missing, :fail)
        case strategy&.to_sym
        when :fail
          fail!("Expected `#{attr}` to be defined", world)
        when :null
          result[attr] = nil
        when :skip
          nil
        else
          raise Monolens::Error, "Unexpected missing strategy `#{strategy}`"
        end
      end
      private :on_missing
    end
  end
end
