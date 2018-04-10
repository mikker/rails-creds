lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'creds/version'

Gem::Specification.new do |spec|
  spec.name          = 'creds'
  spec.version       = Creds::VERSION
  spec.authors       = ['Mikkel Malmberg']
  spec.email         = ['mikkel@brnbw.com']

  spec.summary       = "Shorter, env-scoped version of Rails' credentials"
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 5.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.54'
end
