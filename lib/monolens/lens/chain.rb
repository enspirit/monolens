module Monolens
  module Lens
    class Chain
      include Lens

      def initialize(lenses)
        @lenses = lenses
      end

      def call(*args)
        @lenses.inject(args) do |memo, lens|
          lens.call(*memo)
        end
      end

      class << self
        alias lenses new
      end

      def to_lenses
        @lenses
      end
    end
  end
end
