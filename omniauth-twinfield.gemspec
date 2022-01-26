# frozen_string_literal: true

require_relative "lib/omniauth/twinfield/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-twinfield"
  spec.version = Omniauth::Twinfield::VERSION
  spec.authors = ["murb"]
  spec.email = ["git@murb.nl"]

  spec.summary = "A Twinfield strategy for OmniAuth"
  spec.description = "An OmniAuth strategy for Twinfield, bookkeeping package from Kluwers"
  spec.homepage = "https://gitlab.com/murb-org/omniauth-twinfield"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/murb-org/omniauth-twinfield"
  spec.metadata["changelog_uri"] = "https://gitlab.com/murb-org/omniauth-twinfield/-/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "omniauth-oauth2", "~> 1.7"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
