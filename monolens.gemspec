$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'monolens/version'
require 'date'

Gem::Specification.new do |s|
  s.name        = 'monolens'
  s.version     = Monolens::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Data transformations inspired by Cambria lenses"
  s.description = "Data transformations inspired by Cambria lenses"
  s.authors     = ["Bernard Lambeau"]
  s.email       = 'blambeau@gmail.com'
  s.files       = Dir['LICENSE.md', 'Gemfile','Rakefile', '{bin,lib,spec,tasks}/**/*', 'README*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://github.com/enspirit/monolens'
  s.license     = 'MIT'

  s.bindir = "bin"
  s.executables = (Dir["bin/*"]).collect{|f| File.basename(f)}

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "path", "~> 2"
  s.add_development_dependency "bmg"
end
