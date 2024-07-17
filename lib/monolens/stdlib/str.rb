module Monolens
  module Str
    extend Namespace

    def downcase(options, registry)
      Downcase.new(options, registry)
    end
    module_function :downcase

    def nullIfEmpty(options, registry)
      NullIfEmpty.new(options, registry)
    end
    module_function :nullIfEmpty

    def strip(options, registry)
      Strip.new(options, registry)
    end
    module_function :strip

    def split(options, registry)
      Split.new(options, registry)
    end
    module_function :split

    def upcase(options, registry)
      Upcase.new(options, registry)
    end
    module_function :upcase

    Monolens.define_namespace 'str', self
  end
end
require_relative 'str/downcase'
require_relative 'str/strip'
require_relative 'str/split'
require_relative 'str/upcase'
require_relative 'str/null_if_empty'
