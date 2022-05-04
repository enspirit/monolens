module Monolens
  module Core
    def chain(parts)
      Chain.new(parts)
    end
    module_function :chain

    def map(lens)
      Map.new(lens)
    end
    module_function :map

    Monolens.define_namespace 'core', self
  end
end
require_relative 'core/chain'
require_relative 'core/map'
