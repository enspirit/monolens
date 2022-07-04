module Monolens
  module Core
    extend Namespace

    def chain(options, registry)
      Chain.new(options, registry)
    end
    module_function :chain

    def dig(options, registry)
      Dig.new(options, registry)
    end
    module_function :dig

    def literal(options, registry)
      Literal.new(options, registry)
    end
    module_function :literal

    def mapping(options, registry)
      Mapping.new(options, registry)
    end
    module_function :mapping

    Monolens.define_namespace 'core', self
  end
end
require_relative 'core/chain'
require_relative 'core/dig'
require_relative 'core/mapping'
require_relative 'core/literal'
