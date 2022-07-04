module Monolens
  module Namespace
    def factor_lens(namespace_name, lens_name, options, registry)
      if private_method_defined?(lens_name, false)
        send(lens_name, options, registry)
      else
        raise Error, "No such lens #{[namespace_name, lens_name].join('.')}"
      end
    end
  end
end
