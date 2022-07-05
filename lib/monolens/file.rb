module Monolens
  class File
    include Lens

    signature(Type::Any, Type::Any, {
      version: [Type::Any, true],
      macros: [Type::Map.of(Type::Name, Type::Any), false],
      lenses: [Type::Lenses, true],
    })

    def call(arg, world = {})
      option(:lenses).call(arg, world)
    end
  end
end
