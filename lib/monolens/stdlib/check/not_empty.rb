require 'date'

module Monolens
  module Check
    class NotEmpty
      include Lens

      signature(Type::Emptyable, Type::Emptyable, {
        message: [Type::String, false]
      })

      def call(arg, world = {})
        if arg.nil?
          do_fail!(arg, world)
        elsif arg.respond_to?(:empty?) && arg.empty?
          do_fail!(arg, world)
        else
          arg
        end
      end

    private

      def do_fail!(arg, world)
        message = option(:message, 'Input may not be empty')
        fail!(message, world)
      end
    end
  end
end
