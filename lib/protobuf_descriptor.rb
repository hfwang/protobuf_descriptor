require "protobuf_descriptor/version"

require "stringio"
require "protobuf"
require "protobuf/descriptors/google/protobuf/descriptor.pb.rb"

class ProtobufDescriptor
  def self.decode(bytes)
    return self.decode_from(::StringIO.new(bytes))
  end

  def self.decode_from(stream)
    return self.new(stream)
  end

  def self.load(path)
    return self.decode_from(File.open(path))
  end

  attr_accessor :descripor_set

  def initialize(stream)
    @descriptor_set = Google::Protobuf::FileDescriptorSet.new.decode_from(stream)
  end
end
