# -*- encoding: utf-8 -*-

require File.expand_path('../lib/protobuf_descriptor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "protobuf_descriptor"
  gem.version       = ProtobufDescriptor::VERSION
  gem.summary       = %q{TODO: Summary}
  gem.description   = %q{TODO: Description}
  gem.license       = "MIT"
  gem.authors       = ["Hsiu-Fan Wang"]
  gem.email         = "hfwang@porkbuns.net"
  gem.homepage      = "https://rubygems.org/gems/protobuf_descriptor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end