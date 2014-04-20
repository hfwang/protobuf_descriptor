require "protobuf_descriptor/version"
require "protobuf_descriptor/file_descriptor"
require "protobuf_descriptor/message_descriptor"
require "protobuf_descriptor/named_collection"

require "stringio"
require "protobuf"
require "protobuf/descriptors/google/protobuf/descriptor.pb.rb"

# A wrapper for the
# {+FileDescriptorSet+}[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#49]
# proto. This acts as the root from which name resolution occurs.
class ProtobufDescriptor
  # Decode a ProtobufDescriptor from bytes
  #
  #   ProtobufDescriptor.decode(File.read("descriptor.desc"))
  def self.decode(bytes)
    return self.decode_from(::StringIO.new(bytes))
  end

  # Decode a ProtobufDescriptor from a readable stream
  #
  #   ProtobufDescriptor.decode_from(File.open("descriptor.desc"))
  def self.decode_from(stream)
    return self.new(stream)
  end

  # Loads a ProtobufDescriptor from a file
  #
  #   ProtobufDescriptor.load("descriptor.desc")
  def self.load(path)
    return self.decode_from(File.open(path))
  end

  # Raw FileDescriptorSet protocol buffer
  attr_reader :descriptor_set

  # Set of .proto files that are contained within the descriptor set, as a
  # NamedCollection of {ProtobufDescriptor::FileDescriptor}
  attr_reader :file

  def initialize(stream)
    @descriptor_set = Google::Protobuf::FileDescriptorSet.new.decode_from(stream)
    @file = ProtobufDescriptor::NamedCollection.new(@descriptor_set.file.map { |f| ProtobufDescriptor::FileDescriptor.new(self, f) }) do |name, member|
      member.name == name || member.name == "#{name}.proto"
    end
  end

  alias_method :files, :file

  # Returns all the named descendants of this descriptor set, basically every
  # {ProtobufDescriptor::MessageDescriptor},
  # {ProtobufDescriptor::EnumDescriptor}, and
  # {ProtobufDescriptor::ServiceDescriptor} defined in this set of proto files.
  def all_descendants
    seeds = files.to_a.dup
    children = Set.new
    while !seeds.empty?
      seeds.pop.children.each do |child|
        children << child

        seeds << child if child.respond_to?(:children)
      end
    end
    children
  end

  # Finds the descriptor corresponding to a given type name. +type_name+ can
  # either be a fully qualified name (with a leading "."), or a relative name,
  # in which case +relative_to+ must either be a descriptor or a fully qualified
  # name that the relative name is resolved relative to.
  def resolve_type_name(type_name, relative_to=nil)
    if type_name.start_with?('.')
      all_descendants.find { |descendant|
        descendant.fully_qualified_name == type_name
      }
    else
      raise "Must provide a relative path!" unless relative_to

      relative_to = relative_to.fully_qualified_name if relative_to.respond_to? :fully_qualified_name
      parents = relative_to.split('.')

      # The first element is the empty string, which is the root.
      while parents.size > 1
        type = resolve_type_name("#{parents.join('.')}.#{type_name}")
        return type if type
        parents.pop
      end
    end
  end

  # Shorthand for accessing files
  def [](index)
    return files[index]
  end
end
