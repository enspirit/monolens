module Monolens
  module Str
    def strip(options = {})
      Strip.new(options)
    end
    module_function :strip

    def upcase(options = {})
      Upcase.new(options)
    end
    module_function :upcase

    def downcase(options = {})
      Downcase.new(options)
    end
    module_function :downcase

    Monolens.define_namespace 'str', self
  end
end
require_relative 'str/strip'
require_relative 'str/upcase'
require_relative 'str/downcase'
