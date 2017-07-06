# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "synaccess_connect/version"

Gem::Specification.new do |gem|
  gem.name          = "synaccess_connect"
  gem.version       = SynaccessConnect::VERSION
  gem.authors       = ["Table XI"]
  gem.email         = ["devs@tablexi.com"]
  gem.description   = "Ruby interface to connecting to Synaccess netBooter power relays"
  gem.summary       = ""
  gem.homepage      = "https://github.com/tablexi/synaccess"

  gem.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.require_paths = ["lib"]

  gem.add_dependency 'nokogiri', '> 1.6'

  gem.add_development_dependency 'rspec', '> 2.14'
  gem.add_development_dependency 'vcr', '~> 2.8.0'
  gem.add_development_dependency 'webmock', '< 1.16'
end
