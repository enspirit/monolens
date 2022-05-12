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

        fail!(first_error.message, world)
      end

      def strptime(arg, format = nil)
        if format.nil?
          ::DateTime.strptime(arg)
        else
          ::DateTime.strptime(arg, format)
        end
      end
    end
  end
end
