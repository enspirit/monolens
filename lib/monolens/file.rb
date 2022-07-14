module Monolens
  class File
    include Lens

    signature(Type::Any, Type::Any, {
      version: [Type::Any, true],
      macros: [Type::Map.of(Type::Name, Type::Any), false],
      lenses: [Type::Lenses, true],
      examples: [Type::Array.of(Type::Map.of(Type::Name, Type::Any)), false],
    })

    def call(arg, world = {})
      option(:lenses).call(arg, world)
    end

    def examples
      option(:examples, [])
    end
  end
end
