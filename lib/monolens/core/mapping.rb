module Monolens
  module Core
    class Mapping
      include Lens

      def call(arg, world = {})
        option(:values, {}).fetch(arg) do
          on_missing(arg, world)
        end
      end

    private

      def on_missing(arg, world)
        strategy = option(:on_missing, :fail)
        case strategy.to_sym
        when :fail
          fail!("Unrecognized value `#{arg}`", world)
        when :default
          option(:default, nil)
        when :null
          nil
        when :fallback
          missing_fallback = ->(arg, world) do
            raise Monolens::Error, "Unexpected missing fallback handler"
          end
          option(:fallback, missing_fallback).call(self, arg, world)
        else
          raise Monolens::Error, "Unexpected missing strategy `#{strategy}`"
        end
      end
      private :on_missing
    end
  end
end
