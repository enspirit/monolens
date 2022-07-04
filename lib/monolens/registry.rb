module Monolens
  class Registry
    def initialize(registry = {}, default_namespace = 'core')
      @registry = registry
      @default_namespace = default_namespace
    end

    def define_namespace(name, impl_module)
      @registry[name] = impl_module
    end

    def load_file(file, registry = self)
      load_yaml(::File.read(file), registry)
    end

    def load_yaml(yaml, registry = self)
      Monolens::File.new(YAML.safe_load(yaml), registry)
    end

    def lens(arg, registry = self)
      case arg
      when Lens               then arg
      when ::Array            then chain(arg, registry)
      when ::String, ::Symbol then leaf_lens(arg, registry)
      when ::Hash             then hash_lens(arg, registry)
      else
        raise Error, "No such lens #{arg} (#{arg.class})"
      end
    end

    def fork(default_namespace = 'self')
      Registry.new(@registry.dup, default_namespace)
    end

  private

    def chain(lenses, registry)
      Core::Chain.new(lenses.map{|l| lens(l) }, registry)
    end

    def file_lens(arg, registry)
      File.new(arg, registry)
    end

    def leaf_lens(arg, registry)
      namespace_name, lens_name = arg.to_s.split('.')
      factor_lens(namespace_name, lens_name, {}, registry)
    end

    def hash_lens(arg, registry)
      return file_lens(arg, registry) if arg['version'] || arg[:version]
      raise Error, "Invalid lens #{arg}" unless arg.size == 1

      name, options = arg.to_a.first
      namespace_name, lens_name = if name =~ /^[a-z]+\.[a-z][a-zA-Z]+$/
        name.to_s.split('.')
      else
        [@default_namespace, name]
      end
      factor_lens(namespace_name, lens_name, options, registry)
    end

    def factor_lens(namespace_name, lens_name, options, registry)
      if namespace = @registry[namespace_name]
        namespace.factor_lens(namespace_name, lens_name, options, registry)
      else
        raise Error, "No such namespace #{namespace_name}"
      end
    end
  end
end
