module Monolens
  module Core
    def transform(options = {})
      Transform.new(options)
    end
    module_function :transform

    Monolens.define_namespace 'core', self
  end
end
require_relative 'core/chain'
require_relative 'core/transform'
