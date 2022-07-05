require 'date'

module Monolens
  module Coerce
    class Date
      include Lens

      DEFAULT_FORMATS = [
        nil
      ]

      signature(Type::Coercible.to(Type::String), Type::Date, {
        parser: [Type::DateTimeParser, false],
        formats: [Type::Array.of(Type::String), false]
      })

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
