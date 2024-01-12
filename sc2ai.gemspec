# frozen_string_literal: true

require_relative "lib/sc2ai/version"

Gem::Specification.new do |spec|
  spec.name = "sc2ai"
  spec.version = Sc2::VERSION
  spec.authors = ["Dyson Returns"]

  spec.summary = "Slowly Calmly To An Idea. Count your steps, be mindful of how long they take."

  spec.homepage = "https://github.com/dysonreturns/sc2ai"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/docs/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        %r{\A(?:lib|data|exe)/}.match?(f)
    end
  end
  spec.require_paths = ["lib"]

  # Dependencies ---

  # Dev dependencies ---
  spec.add_development_dependency "rake", "~> 13.1"
  # Doc
  spec.add_development_dependency "yard", "~> 0.9"
  # Linting
  # spec.add_development_dependency "fasterer" # no 3.3 support yet
  spec.add_development_dependency "standard", "~> 1.33"
end
