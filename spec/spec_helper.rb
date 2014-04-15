require 'rspec'
require "protobuf_descriptor"
require "fileutils"
require "tempfile"

def with_temp_file(name="tempfile")
  file = Tempfile.new(name)
  begin
    yield file
  ensure
    file.close
    file.unlink
  end
end

def generate_protobuf_descriptor(args={})
  args = {
    source: ".",
    extra_args: [],
    out: "out.desc"
  }.merge(args)
  args[:source] += '/' unless args[:source].end_with?('/')

  command = []
  command << "protoc"
  command << "-I#{args[:source]}"
  command += args[:extra_args]
  command << "--descriptor_set_out=#{args[:out]}"
  command += Dir.glob("#{args[:source]}**/*.proto")
  full_command = command.join(' ')

  rv = system(*command)

  raise "ProtobufDescriptor generation failed!" unless rv
end

def with_descriptor_file(source, args={})
  with_temp_file do |f|
    args = {
      out: f.path,
      source: "#{File.dirname(__FILE__)}/#{source}/"
    }.merge(args)
    generate_protobuf_descriptor(args)
    yield f
  end
end

def with_descriptor(source, args={})
  with_descriptor_file(source, args) do |f|
    yield ProtobufDescriptor.decode_from(f)
  end
end
