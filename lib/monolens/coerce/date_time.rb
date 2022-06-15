require 'date'

module Monolens
  module Coerce
    # ```
    # coerce.datetime: String|DateTime -> DateTime
    #   formats: [String|Null] = [null]
    #   parser: Any(#parse && #strptime) = DateTime
    # ```
    #
    # This lens takes a String as input and attempts to
    # parse it as a DateTime object.
    #
    # Optional formats can be passed and will be tested
    # against the input string until one of them succeeds
    # (using Ruby's `DateTime#strptime`). A null format
    # indicates the lens to use `DateTime#parse` instead.
    #
    # A specific parser can be passed as option. It must
    # respond to `strptime` and `parse`.
    #
    # When the input is already a DateTime, the lens returns
    # it unchanged.
    class DateTime
      include Lens

      DEFAULT_FORMATS = [
        nil
      ]

      def call(arg, world = {})
        return arg if arg.is_a?(::DateTime)

        is_string!(arg, world)

        date = nil
        first_error = nil
        formats = option(:formats, DEFAULT_FORMATS)
        formats.each do |format|
          begin
            return date = strptime(arg, format)
          rescue ArgumentError => ex
            first_error ||= ex
          rescue ::Date::Error => ex
            first_error ||= ex
          end
        end

        fail!("Invalid DateTime `#{arg}`", world) if first_error
      end

    private

      def strptime(arg, format = nil)
        parsed = if format.nil?
          parser.parse(arg)
        else
          parser.strptime(arg, format)
        end
        parsed = parsed.to_datetime if parsed.respond_to?(:to_datetime)
        parsed
      end

      def parser
        option(:parser, ::DateTime)
      end
    end
  end
end
