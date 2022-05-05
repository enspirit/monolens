module Monolens
  class File
    include Lens

    def call(arg, world = {})
      option(:lenses).call(arg, world)
    end
  end
end
