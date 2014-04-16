# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  require 'rubygems/tasks'

  Gem::Tasks.new
rescue LoadError => e
  warn e.message
  warn "Run `gem install rubygems-tasks` to install Gem::Tasks."
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
rescue LoadError => e
  task :spec do
    abort "Please run `gem install rspec` to install RSpec."
  end
end

task :test    => :spec
task :default => :spec

begin
  gem 'yard', '~> 0.8'
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError => e
  task :yard do
    abort "Please run `gem install yard` to install YARD."
  end
end
task :doc => :yard

task :spec => ["wire-compiler.jar"] do |t|
  # Declare this to ensure wire-compiler is downloaded
end

file "wire-compiler.jar" do |t|
  sh 'wget --no-check-certificate --output-document="wire-compiler.jar" "http://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.squareup.wire&a=wire-compiler&v=LATEST&c=jar-with-dependencies"'
end
