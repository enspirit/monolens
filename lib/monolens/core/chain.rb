module Monolens
  module Core
    class Chain
      include Lens

      def initialize(lenses)
        super({})
        @lenses = lenses
      end

      def call(arg, *rest)
        result = arg
        @lenses.each do |lens|
          done = false
          catch(:skip) do
            result = lens.call(result, *rest)
            done = true
          end
          break unless done
        end
        result
      end
    end
  end
end
