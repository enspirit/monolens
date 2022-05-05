module Monolens
  module Str
    class Strip
      include Lens

      def call(arg, world = {})
        arg.to_s.strip
      end
    end
  end
end
