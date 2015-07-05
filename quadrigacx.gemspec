require File.expand_path('../lib/quadrigacx/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "quadrigacx"
  s.version     = QuadrigaCX::VERSION.dup
  s.summary     = "QuadrigaCX API wrapper"
  s.description = "Ruby wrapper for the QuadrigaCX API"
  s.homepage    = "https://github.com/mhluska/quadrigacx"
  s.authors     = ["Maros Hluska"]
  s.email       = ["mhluska@gmail.com"]
  s.homepage    = "http://mhluska.com/"
  s.license     = "MIT"

  s.add_development_dependency 'byebug',      '~> 5.0'
  s.add_development_dependency 'rspec',       '~> 3.1'
  s.add_development_dependency 'webmock',     '~> 1.20'
  s.add_development_dependency 'vcr',         '~> 2.9'
  s.add_development_dependency 'dotenv',      '~> 1.0'
  s.add_development_dependency 'gem-release', '~> 0.7'

  s.add_runtime_dependency 'json',          '~> 1.8'
  s.add_runtime_dependency 'rest-client',   '~> 1.7'
  s.add_runtime_dependency 'hashie',        '~> 3.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
end
