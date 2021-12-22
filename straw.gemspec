# frozen_string_literal: true

require_relative "lib/straw/version"

Gem::Specification.new do |spec|
  spec.name = "straw"
  spec.version = Straw::VERSION
  spec.authors = ["mo khan"]
  spec.email = ["mo@mokhan.ca"]

  spec.summary = "You can build a lot of things with straw."
  spec.description = "You can build a lot of things with straw."
  spec.homepage = "https://github.com/xlg-pkg/straw"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["changelog_uri"] = "https://github.com/xlg-pkg/straw"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"] = "https://github.com/xlg-pkg/straw"

  spec.files = Dir.glob([
    "*.gemspec",
    "LICENSE.txt",
    "README.md",
    "lib/**/*.rb",
    "sig/**/*.rbs",
  ])

  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ["lib"]
end
