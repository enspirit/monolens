module Monolens
  module Object
    def extend(options)
      Extend.new(options)
    end
    module_function :extend

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

    def select(lens)
      Select.new(lens)
    end
    module_function :select

    Monolens.define_namespace 'object', self
  end
end
require_relative 'object/rename'
require_relative 'object/transform'
require_relative 'object/keys'
require_relative 'object/values'
require_relative 'object/select'
require_relative 'object/extend'
