require 'date'

module Monolens
  module Coerce
    class DateTime
      include Lens

      DEFAULT_FORMATS = [
        nil
      ]

      def call(arg, *rest)
        is_string!(arg)

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

        raise Monolens::LensError, first_error.message
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
