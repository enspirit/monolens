module Monolens
  module Str
    def downcase(options = {})
      Downcase.new(options)
    end
    module_function :downcase

    def strip(options = {})
      Strip.new(options)
    end
    module_function :strip

    def split(options = {})
      Split.new(options)
    end
    module_function :split

    def upcase(options = {})
      Upcase.new(options)
    end
    module_function :upcase

    Monolens.define_namespace 'str', self
  end
end
require_relative 'str/downcase'
require_relative 'str/strip'
require_relative 'str/split'
require_relative 'str/upcase'
