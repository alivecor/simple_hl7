# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_hl7/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rome Portlock"]
  gem.email         = ["rome@alivecor.com"]
  gem.description   = %q{Parse and generate hl7 messages for interfacing with health care systems}
  gem.summary       = %q{Parse and generate hl7 messages}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple_hl7"
  gem.require_paths = ["lib"]
  gem.version       = SimpleHL7::VERSION

  gem.add_development_dependency "pry", "~> 0.9"
  gem.add_development_dependency "rspec", "~> 2.14"
end
