module Monolens
  module Core
    class Mapping
      include Lens

      signature(Type::Any, Type::Any, {
        defn: [Type::Object, false],
        values: [Type::Object, false],    # deprecated
        default: [Type::Any, false],
        fallback: [Type::Callback, false],
        on_missing: [Type::Strategy.missing(%w{default fail fallback keep null}), false]
      })

      def call(arg, world = {})
        option(:defn, option(:values, {})).fetch(arg) do
          on_missing(arg, world)
        end
      end

    private

      def on_missing(arg, world)
        strategy = option(:on_missing, :fail)
        case strategy.to_sym
        when :default
          option(:default, nil)
        when :fail
          fail!("Unrecognized value `#{arg}`", world)
        when :fallback
          missing_fallback = ->(arg, world) do
            raise Monolens::Error, "Unexpected missing fallback handler"
          end
          option(:fallback, missing_fallback).call(self, arg, world)
        when :keep
          arg
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
