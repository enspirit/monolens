require 'date'

module Monolens
  module Coerce
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
