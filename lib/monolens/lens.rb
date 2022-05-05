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

    MISSING_ERROR_HANDLER = <<~TXT
      An :error_handler world entry is required to use error handling
    TXT

    def error_handler!(world)
      _, handler = fetch_on(:error_handler, world)
      return handler if handler

      raise Monolens::Error, MISSING_ERROR_HANDLER
    end

    def is_string!(arg)
      return if arg.is_a?(::String)

      raise Monolens::LensError, "String expected, got #{arg.class}"
    end

    def is_hash!(arg)
      return if arg.is_a?(::Hash)

      raise Monolens::LensError, "Hash expected, got #{arg.class}"
    end

    def is_enumerable!(arg)
      return if arg.is_a?(::Enumerable)

      raise Monolens::LensError, "Enumerable expected, got #{arg.class}"
    end

    def is_array!(arg)
      return if arg.is_a?(::Array)

      raise Monolens::LensError, "Array expected, got #{arg.class}"
    end
  end
end
