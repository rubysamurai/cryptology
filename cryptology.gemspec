require_relative 'lib/cryptology/version'

Gem::Specification.new do |spec|
  spec.name          = 'cryptology'
  spec.version       = Cryptology::VERSION
  spec.authors       = ['Dmitriy Tarasov']
  spec.email         = ['info@rubysamurai.com']

  spec.summary       = 'Symmetric encryption and decryption with OpenSSL'
  spec.description   = 'Symmetric encryption and decryption with OpenSSL'
  spec.homepage      = 'https://github.com/rubysamurai/cryptology'
  spec.license       = 'MIT'

  spec.metadata['bug_tracker_uri'] = 'https://github.com/rubysamurai/cryptology/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/rubysamurai/cryptology/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.add_runtime_dependency 'base64', '>= 0.2.0'

  spec.add_development_dependency 'rake',  '>= 12.0'
  spec.add_development_dependency 'rspec', '>= 3.6'
end
