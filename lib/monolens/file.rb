module Monolens
  class File
    include Lens

    def call(*args, &bl)
      option(:lenses, ->(arg){}).call(*args, &bl)
    end
  end
end
