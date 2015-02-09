# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'callapi/version'

Gem::Specification.new do |spec|
  spec.name          = "callapi"
  spec.version       = Callapi::VERSION
  spec.authors       = ['Kacper Walanus']
  spec.email         = ['kacper@walanus.com']
  spec.summary       = %q{Easy API calls}
  spec.description   = %q{Easy API calls}
  spec.homepage      = 'https://github.com/kv109/Callapi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'addressable', '~> 2.3'
  spec.add_runtime_dependency 'addressabler', '~> 0.1'
  spec.add_runtime_dependency 'multi_json', '~> 1.10'
  spec.add_runtime_dependency 'colorize', '~> 0.7'
  spec.add_runtime_dependency 'activesupport', '~> 4.2'
  spec.add_runtime_dependency 'chainy', '~> 0.0.5'
  spec.add_runtime_dependency 'memoist', '~> 0.11'
end
