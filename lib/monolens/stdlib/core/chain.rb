module Monolens
  module Core
    class Chain
      include Lens

      signature(Type::Any, Type::Any)

      def initialize(options, registry)
        super({}, registry)
        @lenses = options.map{|l| lens(l) }
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
