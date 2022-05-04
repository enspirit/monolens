require 'date'

module Monolens
  module Coerce
    class Date
      include Lens

      def call(arg, *rest)
        is_string!(arg)

        date, first_error = nil, nil
        @options[:formats].each do |format|
          begin
            return date = ::Date.strptime(arg, format)
          rescue ArgumentError => ex
            first_error ||= ex
          rescue ::Date::Error => ex
            first_error ||= ex
          end
        end

        raise Monolens::LensError, first_error.message
      end
    end
  end
end
