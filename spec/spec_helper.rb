require "rspec"
require "protobuf_descriptor"

require "fileutils"
require "pathname"
require "tempfile"
require "tmpdir"
require "zip"

VERBOSE = false

# "Parses" a java package returning a mapping of class/enum names to their fully
# qualified name.
#
# Raises if a class name occurs twice.
def ghetto_parse_java_package(dir)
  if dir.end_with?(".zip")
    Dir.mktmpdir do |temp_dir|
      Zip::File.open(dir) do |zip_file|
        zip_file.each do |entry|
          puts "Making #{temp_dir}/#{File.dirname(entry.name)}" if VERBOSE
          FileUtils.mkdir_p File.join(temp_dir, File.dirname(entry.name))
          puts "Extracting #{temp_dir}/#{entry.name}" if VERBOSE
          entry.extract(File.join(temp_dir, entry.name))
        end
      end
      return ghetto_parse_java_package(temp_dir)
    end
  end

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

    puts "#{filename[dir.length..-1]}: package #{package}" if VERBOSE

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

      puts "#{token}@#{offset} #{bits.inspect}" if VERBOSE
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

def with_descriptor_file(source, args={})
  yield File.open("#{File.dirname(__FILE__)}/protos/#{source}.desc")
end

def find_generated_files(source, kind)
  return "#{File.dirname(__FILE__)}/protos/#{source}.#{kind}.zip"
end

def with_descriptor(source, args={})
  with_descriptor_file(source, args) do |f|
    yield ProtobufDescriptor.decode_from(f)
  end
end

def load_descriptor(source)
  ProtobufDescriptor.load(File.join(File.dirname(__FILE__), "protos", "#{source}.desc"))
end
