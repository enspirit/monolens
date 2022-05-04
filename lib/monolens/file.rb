module Monolens
  class File
    include Lens

    def initialize(info)
      super
      options[:lenses] = Monolens.lens(options[:lenses])
    end

    def call(*args, &bl)
      options[:lenses].call(*args, &bl)
    end
  end
end
