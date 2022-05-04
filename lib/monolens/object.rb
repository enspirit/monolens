module Monolens
  module Object
    def transform(parts)
      Transform.new(parts)
    end
    module_function :transform

    def values(lens)
      Values.new(lens)
    end
    module_function :values

    Monolens.define_namespace 'object', self
  end
end
require_relative 'object/transform'
require_relative 'object/values'
