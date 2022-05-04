require 'date'

module Monolens
  module Coerce
    class Date
      include Lens

      def call(arg, *rest)
        is_string!(arg)

        @options[:formats].each do |format|
          date = ::Date.strptime(arg, format) rescue nil
          return date if date
        end
      end
    end
  end
end
