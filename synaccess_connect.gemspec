# -*- encoding: utf-8 -*-
version = File.open(File.expand_path('VERSION'), 'r').read.strip

Gem::Specification.new do |gem|
  gem.authors       = ["Jason Hanggi"]
  gem.email         = ["jason@tablexi.com"]
  gem.description   = "Ruby interface to connecting to Synaccess netBooter power relays"
  gem.summary       = ""
  gem.homepage      = "https://github.com/tablexi/synaccess"

  gem.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "synaccess_connect"
  gem.require_paths = ["lib"]
  gem.version       = version

  gem.add_dependency 'nokogiri', '> 1.5'

  gem.add_development_dependency 'rspec', '> 2.14'
  gem.add_development_dependency 'vcr', '~> 2.8.0'
  gem.add_development_dependency 'webmock', '< 1.16'
end
