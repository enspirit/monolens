module Monolens
  module Coerce
    def date(options, registry)
      Date.new(options, registry)
    end
    module_function :date

    def integer(options, registry)
      Integer.new(options, registry)
    end
    module_function :integer

    def datetime(options, registry)
      DateTime.new(options, registry)
    end
    module_function :datetime

    def string(options, registry)
      String.new(options, registry)
    end
    module_function :string

    Monolens.define_namespace 'coerce', self
  end
end
require_relative 'coerce/date'
require_relative 'coerce/date_time'
require_relative 'coerce/integer'
require_relative 'coerce/string'
