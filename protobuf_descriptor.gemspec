# -*- encoding: utf-8 -*-

require File.expand_path('../lib/protobuf_descriptor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "protobuf_descriptor"
  gem.version       = ProtobufDescriptor::VERSION
  gem.summary       = %q{Protocol Buffer file descriptor parser}
  gem.description   = %q{Wraps the protobuf FileDescriptorSet messages with happy features like type name resolution and the like.}
  gem.license       = "MIT"
  gem.authors       = ["Hsiu-Fan Wang"]
  gem.email         = "hfwang@porkbuns.net"
  gem.homepage      = "https://github.com/hfwang/protobuf_descriptor"

  gem.files         = `git ls-files`.split($/).reject { |path| /spec\/.+\.(zip|desc)$/.match(path) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'protobuf', '~> 3.0', '>= 3.0.0'

  gem.add_development_dependency "codeclimate-test-reporter"
  gem.add_development_dependency 'pry', '~> 0.9.12.6'
  gem.add_development_dependency 'rake', '~> 10.3'
  gem.add_development_dependency 'rspec', '~> 3.0.0.beta2'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'rubyzip', '~> 1.1'
  gem.add_development_dependency 'yard', '~> 0.8'
end
