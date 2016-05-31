# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file/visitor/version'

Gem::Specification.new do |spec|
  spec.name          = "file-visitor"
  spec.version       = File::Visitor::VERSION
  spec.authors       = ["bonar"]
  spec.email         = ["bonar@me.com"]

  spec.summary       = %q{File path collectiong utility}
  spec.description   = %q{file-visitor is an alternative way to collecting files.}
  spec.homepage      = "https://github.com/bonar/file-visitor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
