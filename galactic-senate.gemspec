
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "galactic-senate/version"

Gem::Specification.new do |spec|
  spec.name          = "galactic-senate"
  spec.version       = GalacticSenate::VERSION
  spec.authors       = ["Jonathan De Jong"]
  spec.email         = ["jonathan@helloglobo.com"]

  spec.summary       = %q{galactic-senate provides a framework backed by redis to identify 1 leader for a set of processes.}
  #spec.description   = %q{}
  spec.homepage      = "https://github.com/jdejong/galactic-senate"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{lib,spec}/**/*")
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'concurrent-ruby', '>= 1.0', '< 2.0'
  spec.add_runtime_dependency 'redis', '>= 3.3.0', '< 7.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
