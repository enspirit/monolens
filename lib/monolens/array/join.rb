module Monolens
  module Array
    class Join
      include Lens

      def call(arg, *rest)
        is_array!(arg)

        arg.join(separator)
      end

      def separator
        _, separator = fetch_on(:separator, options)
        separator || ' '
      end
      private :separator
    end
  end
end
