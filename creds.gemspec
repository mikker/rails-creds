lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "creds/version"

Gem::Specification.new do |spec|
  spec.name = "rails-creds"
  spec.version = Creds::VERSION
  spec.authors = ["Mikkel Malmberg"]
  spec.email = ["mikkel@brnbw.com"]

  spec.summary = "Shorter, env-scoped version of Rails' credentials"
  spec.description = ""
  spec.homepage = "https://github.com/mikker/rails-creds"
  spec.metadata = {"source_code_uri" => "https://github.com/mikker/rails-creds"}
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "> 5.2"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 0.1.0"
end