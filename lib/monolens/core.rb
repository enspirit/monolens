module Monolens
  module Core
    def chain(parts)
      Chain.new(parts)
    end
    module_function :chain

    Monolens.define_namespace 'core', self
  end
end
require_relative 'core/chain'
