module Monolens
  module Check
    def notEmpty(options)
      NotEmpty.new(options)
    end
    module_function :notEmpty

    Monolens.define_namespace 'check', self
  end
end
require_relative 'check/not_empty'
