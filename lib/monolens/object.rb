module Monolens
  module Object
    def rename(parts)
      Rename.new(parts)
    end
    module_function :rename

    def transform(parts)
      Transform.new(parts)
    end
    module_function :transform

    def keys(lens)
      Keys.new(lens)
    end
    module_function :keys

    def values(lens)
      Values.new(lens)
    end
    module_function :values

    Monolens.define_namespace 'object', self
  end
end
require_relative 'object/rename'
require_relative 'object/transform'
require_relative 'object/keys'
require_relative 'object/values'
