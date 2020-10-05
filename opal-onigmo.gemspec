require_relative 'lib/opal/onigmo/version'

Gem::Specification.new do |spec|
  spec.name          = "opal-onigmo"
  spec.version       = Opal::Onigmo::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = %q{Execute regexps with Opal using Onigmo}
  spec.description   = %q{Execute regexps in Opal with a native Ruby regexp engine - Onigmo - compiled using clang to WebAssembly}
  spec.homepage      = "https://github.com/interscript/opal-onigmo"
  spec.license       = "BSD-2-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/interscript/opal-onigmo"
  spec.metadata["changelog_uri"] = "https://github.com/interscript/opal-onigmo/commits/master"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|Onigmo)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "opal-webassembly", "~> 0.1"
end
