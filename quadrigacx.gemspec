# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quadrigacx/version'

Gem::Specification.new do |spec|
  spec.name          = 'quadrigacx'
  spec.version       = QuadrigaCX::VERSION
  spec.author        = 'Maros Hluska'
  spec.email         = 'mhluska@gmail.com'
  spec.summary       = 'QuadrigaCX API wrapper'
  spec.description   = 'Ruby wrapper for the QuadrigaCX API'
  spec.homepage      = 'https://github.com/mhluska/quadrigacx'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'json',        '~> 1.8'
  spec.add_runtime_dependency 'rest-client', '~> 1.7'
  spec.add_runtime_dependency 'hashie',      '~> 3.3'

  spec.add_development_dependency 'byebug',      '~> 5.0'
  spec.add_development_dependency 'rspec',       '~> 3.1'
  spec.add_development_dependency 'webmock',     '~> 1.20'
  spec.add_development_dependency 'vcr',         '~> 2.9'
  spec.add_development_dependency 'dotenv',      '~> 1.0'
  spec.add_development_dependency 'gem-release', '~> 0.7'
  spec.add_development_dependency 'bundler',     '~> 1.7'
  spec.add_development_dependency 'rake',        '~> 10.0'
end
