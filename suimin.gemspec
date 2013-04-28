# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'suimin/version'

Gem::Specification.new do |gem|
  gem.name          = "suimin"
  gem.version       = Suimin::VERSION
  gem.authors       = ["Koichi Hirano"]
  gem.email         = ["internalist@gmail.com"]
  gem.description   = %q{A gem which provides a method that sleeps in the way you want}
  gem.summary       = %q{When you need to have a sleeping behavior following a certain statistical distribution, this is the gem for you.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.10'
end
