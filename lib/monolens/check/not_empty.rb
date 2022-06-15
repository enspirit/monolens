require 'date'

module Monolens
  module Check
    # ```
    # check.notEmpty: Any -> Any, {
    #   message: String = 'Input may not be empty'
    # }
    # ```
    #
    # This lens takes an Array, Object or String as input
    # and fails when empty. Otherwise the input is returned.
    #
    # The lens also fails if the input is null.
    class NotEmpty
      include Lens

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
