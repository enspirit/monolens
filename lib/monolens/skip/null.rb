module Monolens
  module Skip
    # ```
    # skip.null: Any -> Any
    # ```
    #
    # This lens can be used to send a `skip` message to
    # higher stages when the input is null.
    #
    # The message will be cached by `skip` handlers on
    # `on_missing` and `on_error` clauses.
    class Null
      include Lens

      def call(arg, world = {})
        throw :skip if arg.nil?

        arg
      end
    end
  end
end
