# frozen_string_literal: true

source "https://rubygems.org"

if Gem.win_platform?
  # These only matter on windows
  gem "kdtree", git: "https://github.com/dysonreturns/kdtree.git", branch: "master"
  gem "async-process", git: "https://github.com/dysonreturns/async-process.git", branch: "windows-pgroup-params"
end

# Specify your gem's dependencies in sc2ai.gemspec
gemspec
