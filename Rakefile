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

desc "Compiles the protocol buffer decls used by the specs"
task :compile_spec_protos do
  require "pathname"
  require "tempfile"
  require "tmpdir"
  require "zip"

  VERBOSE = ENV["VERBOSE"]

  exec_proto_compiler = lambda do |args|
    args = {
      :source => ".",
      :extra_args => [],
      :plugin => nil,
      :plugin_out => "",
      :out => "out.desc",
      :include_source_info => false,
    }.merge(args)
    args[:source] += '/' unless args[:source].end_with?('/')

    command = []
    command << "protoc"
    command << "-I#{args[:source]}"
    if args[:plugin]
      command << "--#{args[:plugin]}_out=#{args[:plugin_out]}"
    end
    command += args[:extra_args]
    command << "--descriptor_set_out=#{args[:out]}"
    if args[:include_source_info]
      command << "--include_source_info"
    end
    command += Dir.glob(File.join(args[:source], "**", "*.proto"))

    rv = system(*command)

    raise "ProtobufDescriptor generation failed!" unless rv
  end

  exec_wire_compiler = lambda do |args|
    args = {
      :out => ".",
      :source => ".",
      :extra_args => []
    }.merge(args)

    jar_path = File.realpath(File.join(File.dirname(__FILE__), "wire-compiler.jar"))
    command = ["java", "-jar", jar_path]
    command << "--proto_path=#{args[:source]}"
    command += args[:extra_args]
    command << "--java_out=#{args[:out]}"
    sources = Dir.glob(File.join(args[:source], "**", "*.proto")).map { |p|
      Pathname.new(p).relative_path_from(Pathname.new(args[:source])).to_s
    }
    command += sources

    tmp_log = Tempfile.new(["wire-compiler", ".log"])
    begin
      rv = system(*command, out: [tmp_log.path, "a"], err: [tmp_log.path, "a"])
      puts File.read(tmp_log) if VERBOSE

      raise "Wire protobuf generation failed!\n#{File.read(tmp_log)}" unless rv
    ensure
      tmp_log.close
      tmp_log.unlink
    end
  end
  create_zip = lambda do |dir, dest|
    dirpath = Pathname.new(dir)
    File.delete(dest) if File.exist?(dest)
    Zip::File.open(dest, Zip::File::CREATE) do |zipfile|
      # require "pry"
      # binding.pry
      (Dir[File.join(dir, "**", "**")] + Dir[File.join(dir, "**")]).uniq.each do |file|
        next if File.directory?(file)
        relative_path = Pathname.new(file).relative_path_from(dirpath)
        zipfile.add(relative_path, file)
        puts "#{dest} <- #{relative_path}" if VERBOSE
      end
    end
  end

  file_sets = Dir["spec/protos/*"].select { |d| File.directory?(d) }

  source = "spec/protos/source_info"
  puts "Building #{source} (with included source info)"
  exec_proto_compiler.call({
    :out => "#{source}.srcinfo.desc",
    :source => source,
    :include_source_info => true
  })
  file_sets.each do |source|
    puts "Building #{source}"
    Dir.mktmpdir do |dir|
      args = {
        :out => "#{source}.desc",
        :source => source,
        :plugin => :java,
        :plugin_out => dir
      }
      exec_proto_compiler.call(args)
      create_zip.call(dir, "#{source}.java.zip")
    end

    Dir.mktmpdir do |dir|
      args = {
        :source => source,
        :out => dir
      }
      exec_wire_compiler.call(args)
      create_zip.call(dir, "#{source}.wire.zip")
    end
  end
end

file "wire-compiler.jar" do |t|
  sh 'wget --no-check-certificate --output-document="wire-compiler.jar" "http://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.squareup.wire&a=wire-compiler&v=LATEST&c=jar-with-dependencies"'
end
