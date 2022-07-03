require_relative 'lens/fetch_support'
require_relative 'lens/options'
require_relative 'lens/location'

module Monolens
  module Lens
    include FetchSupport

    def initialize(options = {})
      @options = Options.new(options)
    end
    attr_reader :options

    def fail!(msg, world)
      location = world[:location]&.to_a || []
      raise Monolens::LensError.new(msg, location)
    end

  protected

    def lens(*args)
      options.lens(*args)
    end

    def option(name, default = nil)
      @options.fetch(name, default)
    end

    def deeper(world, part)
      world[:location] ||= Location.new
      world[:location].deeper(part) do |loc|
        yield(world.merge(location: loc))
      end
    end

    MISSING_ERROR_HANDLER = <<~TXT
      An :error_handler world entry is required to use error handling
    TXT

    def error_handler!(world)
      _, handler = fetch_on(:error_handler, world)
      return handler if handler

      raise Monolens::Error, MISSING_ERROR_HANDLER
    end

    def is_string!(arg, world)
      return if arg.is_a?(::String)

      fail!("String expected, got #{arg.class}", world)
    end

    def is_hash!(arg, world)
      return if arg.is_a?(::Hash)

      fail!("Hash expected, got #{arg.class}", world)
    end

    def is_enumerable!(arg, world)
      return if arg.is_a?(::Enumerable)

      fail!("Enumerable expected, got #{arg.class}", world)
    end

    def is_array!(arg, world)
      return if arg.is_a?(::Array)

      fail!("Array expected, got #{arg.class}", world)
    end
  end
end
