module Monolens
  module Core
    # ```
    # coerce.chain: [Lens] -> Lens
    # ```
    #
    # This lens simply takes a list of sublenses and apply
    # them in order (functional composition).
    #
    # It is mostly implicit when using .yaml files and is used
    # for constructions like this:
    #
    # ```
    # lenses:
    # - ...
    # - ...
    # ```
    #
    class Chain
      include Lens

      def initialize(lenses)
        super({})
        @lenses = lenses
      end

      def call(arg, world = {})
        result = arg
        @lenses.each do |lens|
          done = false
          catch(:skip) do
            result = lens.call(result, world)
            done = true
          end
          break unless done
        end
        result
      end
    end
  end
end
