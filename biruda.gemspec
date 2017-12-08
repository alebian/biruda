# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'biruda/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = "biruda"
  spec.version       = Biruda::VERSION
  spec.authors       = ['Alejandro Bezdjian']
  spec.email         = ['alebezdjian@gmail.com']
  spec.date          = Date.today
  spec.summary       = 'Simple DSL to build HTML documents'
  spec.description   = 'Simple DSL to build HTML documents'
  spec.homepage      = 'https://github.com/alebian/biruda'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']
  spec.license       = 'MIT'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'byebug', '~> 9.1'
  spec.add_development_dependency 'rubocop', '~> 0.51'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'simplecov', '~> 0.15'
end
