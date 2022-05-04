module Monolens
  module Array
    def compact(options = {})
      Compact.new(options)
    end
    module_function :compact

    Monolens.define_namespace 'array', self
  end
end
require_relative 'array/compact'
