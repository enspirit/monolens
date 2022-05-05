require_relative 'lens/fetch_support'
require_relative 'lens/options'

module Monolens
  module Lens
    include FetchSupport

    def initialize(options = {})
      @options = Options.new(options)
    end
    attr_reader :options

    def option(name, default = nil)
      @options.fetch(name, default)
    end

    def is_string!(arg)
      return if arg.is_a?(::String)

      raise Monolens::Error, "String expected, got #{arg.class}"
    end

    def is_hash!(arg)
      return if arg.is_a?(::Hash)

      raise Monolens::Error, "Hash expected, got #{arg.class}"
    end

    def is_enumerable!(arg)
      return if arg.is_a?(::Enumerable)

      raise Monolens::Error, "Enumerable expected, got #{arg.class}"
    end

    def is_array!(arg)
      return if arg.is_a?(::Array)

      raise Monolens::Error, "Array expected, got #{arg.class}"
    end
  end
end
