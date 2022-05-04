require 'finitio'
require 'yaml'
module Monolens
  require_relative 'monolens/version'
  require_relative 'monolens/lens'
  require_relative 'monolens/lens/chain'
  require_relative 'monolens/lens/file'
  require_relative 'monolens/lens/strip'
  require_relative 'monolens/lens/upcase'

  SYSTEM_PATH = ::File.expand_path('monolens/system.fio', __dir__)

  SYSTEM = Finitio.system(::File.read(SYSTEM_PATH))

  def self.load_file(file)
    SYSTEM['Lenses.File'].dress(YAML.load(::File.read(file)))
  end
end
