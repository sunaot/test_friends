# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_friends/version'

Gem::Specification.new do |spec|
  spec.name          = "test_friends"
  spec.version       = TestFriends::VERSION
  spec.authors       = ["sunaot"]
  spec.email         = ["sunao.tanabe@gmail.com"]
  spec.description   = %q{Helpful tools for unit testing}
  spec.summary       = %q{TestFriends gem is a library bundle to help your unit testing.}
  spec.homepage      = "https://github.com/sunaot/test_friends"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
