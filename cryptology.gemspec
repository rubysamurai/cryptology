# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cryptology/version'

Gem::Specification.new do |spec|
  spec.name          = 'cryptology'
  spec.version       = Cryptology::VERSION
  spec.authors       = ['Dmitriy Tarasov']
  spec.email         = ['info@rubysamurai.com']

  spec.summary       = 'Wrapper for symmetric encryption and decryption using any algorithm supported by OpenSSL'
  spec.description   = 'Wrapper for symmetric encryption and decryption using any algorithm supported by OpenSSL'
  spec.homepage      = 'https://github.com/rubysamurai/cryptology'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency 'rake',  '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
end
