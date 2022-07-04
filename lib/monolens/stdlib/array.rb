module Monolens
  module Array
    extend Namespace

    def compact(options, registry)
      Compact.new(options, registry)
    end
    module_function :compact

    def join(options, registry)
      Join.new(options, registry)
    end
    module_function :join

    def map(options, registry)
      Map.new(options, registry)
    end
    module_function :map

    Monolens.define_namespace 'array', self
  end
end
require_relative 'array/compact'
require_relative 'array/join'
require_relative 'array/map'
