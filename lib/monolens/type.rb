module Monolens
  module Type
    module ErrorHandling
      def fail!(message, &block)
        block.call(message)
      end
    end

    require_relative 'type/any'
    require_relative 'type/array'
    require_relative 'type/boolean'
    require_relative 'type/callback'
    require_relative 'type/coercible'
    require_relative 'type/emptyable'
    require_relative 'type/diggable'
    require_relative 'type/integer'
    require_relative 'type/map'
    require_relative 'type/responding'
    require_relative 'type/lenses'
    require_relative 'type/object'
    require_relative 'type/strategy'
    require_relative 'type/string'
    require_relative 'type/symbol'

    Date = ::Date

    DateTime = ::DateTime

    DateTimeParser = Responding.to(:parse, :strptime)

    Name = Any.of(Type::Symbol, Type::String)
  end
end
