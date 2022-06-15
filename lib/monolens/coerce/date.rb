require 'date'

module Monolens
  module Coerce
    # ```
    # coerce.date: String|Date -> Date
    #   formats: [String|Null] = [null]
    # ```
    #
    # This lens takes a String as input and attempts to
    # parse it as a Date object.
    #
    # Optional formats can be passed and will be tested
    # against the input string until one of them succeeds
    # (using Ruby's `Date#strptime`).
    #
    # When the input is already a Date, the lens returns
    # it unchanged.
    class Date
      include Lens

      DEFAULT_FORMATS = [
        nil
      ]

      def call(arg, world = {})
        return arg if arg.is_a?(::Date)

        is_string!(arg, world)

        date = nil
        first_error = nil
        formats = @options.fetch(:formats, DEFAULT_FORMATS)
        formats.each do |format|
          begin
            return date = strptime(arg, format)
          rescue ArgumentError => ex
            first_error ||= ex
          rescue ::Date::Error => ex
            first_error ||= ex
          end
        end

        fail!("Invalid date `#{arg}`", world) if first_error
      end

      def strptime(arg, format = nil)
        if format.nil?
          ::Date.strptime(arg)
        else
          ::Date.strptime(arg, format)
        end
      end
    end
  end
end
