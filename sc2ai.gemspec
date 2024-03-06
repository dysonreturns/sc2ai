# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("./lib"))
require_relative "lib/sc2ai/version"

Gem::Specification.new do |spec|
  spec.name = "sc2ai"
  spec.version = Sc2::VERSION
  spec.authors = ["Dyson Returns"]

  spec.summary = "STARCRAFT® II AI API"
  spec.description = "This is a Ruby interface to STARCRAFT® II. It can be used for machine learning via Rumale or custom scripted AI battle."
  spec.homepage = "https://www.github.com/dysonreturns/sc2ai"
  spec.licenses = ["MIT", "Nonstandard"]
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/docs/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        %r{\A(?:lib|data|exe|sig)/}.match?(f)
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Live dependencies ---
  spec.add_dependency "async", "~> 2.6.5"
  # Sc2::Connection
  spec.add_dependency "async-websocket", "~> 0.26.0"
  spec.add_dependency "google-protobuf", "~> 3.25.3"
  # Sc2::Client / Controller
  spec.add_dependency "async-process", "~> 1.3.1"
  # Cli
  spec.add_dependency "thor", "~> 1.3.0"

  # Geometry
  spec.add_dependency "perfect-shape", "~> 1.0.8"

  spec.add_dependency "numo-narray", "~> 0.9.2.1"
  spec.add_dependency "numo-linalg", "~> 0.1.7"
  spec.add_dependency "rumale", "~> 0.28.1"

  # TODO: Find a way to not depend on a patched gem and yank this
  spec.add_dependency "sc2ai-kdtree", "~> 0.4"

  # Pre-packaged ladder dependencies
  # We add these locally, so that authors know what to use
  # spec.add_dependency "activerecord", "7.1.2"
  # spec.add_dependency "sqlite3", "1.7.0"
  # spec.add_dependency "rb_sys", "0.9.85"
  # spec.add_dependency "concurrent-ruby", "1.2.2"
  # spec.add_dependency "parallel", "1.24.0"

  # Dev dependencies ---
  spec.add_development_dependency "rake", "~> 13.1"
  # Doc
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "webrick", "~> 1.8"
  # Sig
  spec.add_development_dependency "sord"
  #spec.add_development_dependency "rbs_protobuf", "~> 1.2"
  #spec.add_development_dependency "protobuf", "~> 3.10" # _only_ required for signatures

  # Linting
  # spec.add_development_dependency "fasterer" # no 3.3 support yet
  spec.add_development_dependency "standard", "~> 1.33"

  # Profiling
  spec.add_development_dependency "memory_profiler", "~> 1.0"
  spec.add_development_dependency "benchmark", "~> 0.3"
  spec.add_development_dependency "benchmark-ips", "~> 2.13"

  # Testing
  spec.add_development_dependency "factory_bot", "~> 6.4"
  spec.add_development_dependency "fakefs", "~> 2.5"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "simplecov", "~> 0.22"
end
