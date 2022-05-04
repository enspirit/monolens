module Monolens
  module Skip
    def null(options = {})
      Null.new(options)
    end
    module_function :null

    Monolens.define_namespace 'skip', self
  end
end
require_relative 'skip/null'
