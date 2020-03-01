# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cryptology/version'

Gem::Specification.new do |spec|
  spec.name          = 'cryptology'
  spec.version       = Cryptology::VERSION
  spec.authors       = ['Dmitriy Tarasov']
  spec.email         = ['info@rubysamurai.com']

  spec.summary       = 'Symmetric encryption and decryption with OpenSSL'
  spec.description   = 'Symmetric encryption and decryption with OpenSSL'
  spec.homepage      = 'https://github.com/rubysamurai/cryptology'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_development_dependency 'rake',  '>= 12.0'
  spec.add_development_dependency 'rspec', '>= 3.6'
end
