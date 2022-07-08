module Monolens
  module Object
    extend Namespace

    def allbut(options, registry)
      Allbut.new(options, registry)
    end
    module_function :allbut

    def extend(options, registry)
      Extend.new(options, registry)
    end
    module_function :extend

    def rename(options, registry)
      Rename.new(options, registry)
    end
    module_function :rename

    def transform(options, registry)
      Transform.new(options, registry)
    end
    module_function :transform

    def keys(options, registry)
      Keys.new(options, registry)
    end
    module_function :keys

    def values(options, registry)
      Values.new(options, registry)
    end
    module_function :values

    def select(options, registry)
      Select.new(options, registry)
    end
    module_function :select

    def merge(options, registry)
      Merge.new(options, registry)
    end
    module_function :merge

    Monolens.define_namespace 'object', self
  end
end
require_relative 'object/allbut'
require_relative 'object/rename'
require_relative 'object/transform'
require_relative 'object/keys'
require_relative 'object/values'
require_relative 'object/select'
require_relative 'object/extend'
require_relative 'object/merge'
