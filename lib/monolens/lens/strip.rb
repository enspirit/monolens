module Monolens
  module Lens
    class Strip
      include Lens

      def call(arg, *rest)
        arg.to_s.strip
      end
    end
  end
end
