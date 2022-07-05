module Monolens
  module Lens
    class Signature
      class Missing < Signature
        def _dress_options(options, registry)
          options
        end
      end
    end
  end
end
