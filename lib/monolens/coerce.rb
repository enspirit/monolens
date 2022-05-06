module Monolens
  module Coerce
    def date(options = {})
      Date.new(options)
    end
    module_function :date

    def datetime(options = {})
      DateTime.new(options)
    end
    module_function :datetime

    def string(options = {})
      String.new(options)
    end
    module_function :string

    Monolens.define_namespace 'coerce', self
  end
end
require_relative 'coerce/date'
require_relative 'coerce/date_time'
require_relative 'coerce/string'
