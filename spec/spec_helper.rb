require 'rspec'
require "protobuf_descriptor"

require "fileutils"
require "pathname"
require "tempfile"

# "Parses" a java package returning a mapping of class/enum names to their fully
# qualified name.
#
# Raises if a class name occurs twice.
def ghetto_parse_java_package(dir)
  tokens = [
    # Wire enum
    [:enum, /public\s+enum\s+(\w+)\s+implements\s+ProtoEnum\s+{/],
    # Protoc Java enum
    [:enum, /public\s+enum\s+(\w+)\s+implements\s+com\.google\.protobuf\.ProtocolMessageEnum\s+{/],
    # This is used by the protocol buffer compiler to wrap all the protos
    # defined in a single file.
    [:namespace, /public\s+(?:(?:static|final)\s+)*class\s+(\w+)\s+{/],
    # Wire message type
    [:message, /public\s+(?:(?:static|final)\s+)*class\s+(\w+)\s+extends\s+Message\s+{/],
    # Protoc java message
    [:message, /public\s+(?:(?:static|final)\s+)*class\s+(\w+)\s+extends\s+com\.google\.protobuf\.GeneratedMessage\s+implements\s+(\w+)\s+{/],
    [:open_brace, /{/],
    [:close_brace, /}/],
    [:eof, /\z/]]

  found = {}

  Dir.glob("#{dir}/**/*.java").each do |filename|
    contents = File.read(filename)

    package = contents.match(/package\s+([\w\.]+);/)
    package = package[1] unless package.nil?

    # puts "#{filename[dir.length..-1]}: package #{package}"

    bits = [package]

    offset = 0
    while offset < contents.length
      token, regex = tokens.min_by { |k, v|
        match = v.match(contents, offset)
        # Move offset off end of file so EOF matches first.
        match.nil? ? contents.length + 1: match.begin(0)
      }
      match = regex.match(contents, offset)
      offset = match.end(0)

      # Build a stack of named components
      case token
      when :enum, :message
        # If we find a named component, add it to the stack as well as
        # generating its portion of the output.
        bits.push(match[1])
        raise "Type name #{match[1]} occurs twice!" if found[match[1]]
        found[match[1]] = bits.compact.join('.')
      when :namespace
        bits.push(match[1])
      when :open_brace
        bits.push(nil)
      when :close_brace
        bits.pop
      end

      # puts "#{token}@#{offset} #{bits.inspect}"
    end
  end
  return found
end

def with_temp_file(name="tempfile")
  file = Tempfile.new(name)
  begin
    yield file
  ensure
    file.close
    file.unlink
  end
end

def compile_wire_protobuf(args={})
  args = {
    destination: ".",
    source: ".",
    extra_args: []
  }.merge(args)

  jar_path = File.realpath("#{File.dirname(__FILE__)}/../wire-compiler.jar")
  command = ["java", "-jar", jar_path]
  command << "--proto_path=#{args[:source]}"
  command += args[:extra_args]
  command << "--java_out=#{args[:destination]}"
  command += Dir.glob("#{args[:source]}**/*.proto").map { |p|
    Pathname.new(p).relative_path_from(Pathname.new(args[:source])).to_s
  }
  with_temp_file do |tmp_log|
    rv = system(*command, out: [tmp_log.path, "a"], err: [tmp_log.path, "a"])

    raise "Wire protobuf generation failed!\n#{File.read(tmp_log)}" unless rv
  end
end

def generate_protobuf_descriptor(args={})
  args = {
    source: ".",
    extra_args: [],
    plugin: nil,
    plugin_out: "",
    out: "out.desc"
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
  command += Dir.glob("#{args[:source]}**/*.proto")

  rv = system(*command)

  raise "ProtobufDescriptor generation failed!" unless rv
end

def with_descriptor_file(source, args={})
  with_temp_file do |f|
    args = {
      out: f.path,
      source: "#{File.dirname(__FILE__)}/protos/#{source}/"
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
