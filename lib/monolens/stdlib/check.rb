module Monolens
  module Check
    def notEmpty(options, registry)
      NotEmpty.new(options, registry)
    end
    module_function :notEmpty

    Monolens.define_namespace 'check', self
  end
end
require_relative 'check/not_empty'
