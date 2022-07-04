require 'yaml'
require 'ostruct'

module Monolens
  require_relative 'monolens/version'
  require_relative 'monolens/error'
  require_relative 'monolens/error_handler'
  require_relative 'monolens/utils'
  require_relative 'monolens/lens'
  require_relative 'monolens/namespace'
  require_relative 'monolens/registry'

  STDLIB = Registry.new

  class << self
    def define_namespace(name, impl_module)
      STDLIB.define_namespace(name, impl_module)
    end

    def load_file(file)
      STDLIB.load_file(file)
    end

    def load_yaml(yaml_str)
      STDLIB.load_yaml(yaml_str)
    end

    def lens(arg)
      STDLIB.lens(arg)
    end
  end

  require_relative 'monolens/file'
  require_relative 'monolens/stdlib'
end
