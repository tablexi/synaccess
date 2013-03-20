# -*- encoding: utf-8 -*-
# require File.expand_path('../lib/synaccess_connect/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jason"]
  gem.email         = ["jason@tablexi.com"]
  gem.description   = ""
  gem.summary       = ""
  gem.homepage      = ""

  # gem.files         = `git ls-files`.split($\)
  gem.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "synaccess_connect"
  gem.require_paths = ["lib"]
  gem.version       = "0.1.0"

  gem.add_dependency 'nokogiri', '~> 1.5.8'

  gem.add_development_dependency 'rspec',   '~> 2.13.0'
  gem.add_development_dependency 'vcr',     '~> 2.4.0'
  gem.add_development_dependency 'webmock', '~> 1.11.0'
end
