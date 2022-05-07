module Monolens
  module Core
    def chain(parts)
      Chain.new(parts)
    end
    module_function :chain

    def dig(options)
      Dig.new(options)
    end
    module_function :dig

    def mapping(options)
      Mapping.new(options)
    end
    module_function :mapping

    Monolens.define_namespace 'core', self
  end
end
require_relative 'core/chain'
require_relative 'core/dig'
require_relative 'core/mapping'
