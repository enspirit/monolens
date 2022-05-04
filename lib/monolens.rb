require 'yaml'
module Monolens
  NAMESPACES = { }

  class << self
    require_relative 'monolens/version'
    require_relative 'monolens/error'
    require_relative 'monolens/lens'

    def define_namespace(name, impl_module)
      NAMESPACES[name] = impl_module
    end

    require_relative 'monolens/file'
    require_relative 'monolens/core'
    require_relative 'monolens/skip'
    require_relative 'monolens/str'
    require_relative 'monolens/coerce'

    def load_file(file)
      Monolens::File.new(YAML.safe_load(::File.read(file)))
    end

    def lens(arg)
      case arg
      when Lens           then arg
      when Array          then chain(arg)
      when String, Symbol then leaf_lens(arg)
      when Hash           then hash_lens(arg)
      else
        raise Error, "No such lens #{[namespace_name, lens_name].join('.')}"
      end
    end

    def chain(lenses)
      Core::Chain.new(lenses.map{|l| lens(l) })
    end
    private :chain

    def leaf_lens(arg)
      namespace_name, lens_name = arg.to_s.split('.')
      factor_lens(namespace_name, lens_name, {})
    end
    private :leaf_lens

    def hash_lens(arg)
      raise "Invalid lens #{arg}" unless arg.size == 1

      name, options = arg.to_a.first
      namespace_name, lens_name = if name =~ /^[a-z]+\.[a-z]+$/
        name.to_s.split('.')
      else
        ['core', name]
      end
      factor_lens(namespace_name, lens_name, options)
    end
    private :hash_lens

    def factor_lens(namespace_name, lens_name, options)
      namespace = NAMESPACES[namespace_name]
      if namespace&.private_method_defined?(lens_name, false)
        namespace.send(lens_name, options)
      else
        raise Error, "No such lens #{[namespace_name, lens_name].join('.')}"
      end
    end
    private :factor_lens
  end
end
