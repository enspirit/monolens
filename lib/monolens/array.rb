module Monolens
  module Array
    def compact(options = {})
      Compact.new(options)
    end
    module_function :compact

    def join(options = {})
      Join.new(options)
    end
    module_function :join

    Monolens.define_namespace 'array', self
  end
end
require_relative 'array/compact'
require_relative 'array/join'
