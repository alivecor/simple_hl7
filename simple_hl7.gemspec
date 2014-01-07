# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_hl7/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rome Portlock"]
  gem.email         = ["rome@alivecor.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple_hl7"
  gem.require_paths = ["lib"]
  gem.version       = SimpleHl7::VERSION
end
