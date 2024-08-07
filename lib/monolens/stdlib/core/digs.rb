module Monolens
  module Core
    class Digs
      include Lens

      signature(Type::Diggable, Type::Any, {
        defn: [
          Type::Array.of(Type::Array.of(Type::Any.of(Type::Integer, Type::String))),
          true
        ],
        on_missing: [Type::Strategy.missing(%w{fail null}), false]
      })

      def call(arg, world = {})
        to_dig = option(:defn, [])
        to_dig.map {|digging|
          digging.inject(arg) do |memo, part|
            dig_on(part, memo, world)
          end
        }
      end

    private

      def path
        option(:defn, []).join('.')
      end

      def dig_on(attr, arg, world)
        if arg.is_a?(::Array)
          index = attr.to_i
          on_missing(world) if index >= arg.size
          arg[index]
        elsif arg.is_a?(::Hash)
          actual, value = fetch_on(attr, arg)
          on_missing(world) unless actual
          value
        elsif arg
          if attr.is_a?(::Integer)
            is_array!(arg, world)
          else
            is_hash!(arg, world)
          end
        else
          on_missing(world)
        end
      end

      def on_missing(world)
        strategy = option(:on_missing, :fail)
        case strategy.to_sym
        when :fail
          fail!("Unable to find #{path}", world)
        when :null
          nil
        else
          raise Monolens::Error, "Unexpected missing strategy `#{strategy}`"
        end
      end
      private :on_missing
    end
  end
end
