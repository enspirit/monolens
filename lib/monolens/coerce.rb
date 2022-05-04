module Monolens
  module Coerce
    def date(options = {})
      Date.new(options)
    end
    module_function :date

    Monolens.define_namespace 'coerce', self
  end
end
require_relative 'str/strip'
require_relative 'str/upcase'
require_relative 'str/downcase'
require_relative 'coerce/date'
