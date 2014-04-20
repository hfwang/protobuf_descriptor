require "active_support"
require "protobuf_descriptor/named_child"
require "active_support/core_ext/module/delegation"

class ProtobufDescriptor
  # Describes an enum type.
  #
  # See {+EnumDescriptorProto+}[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#84]
  class EnumDescriptor
    # The containing FileDescriptor[link:FileDescriptor.html]
    # or MessageDescriptor[link:MessageDescriptor.html] that
    # defines this enum.
    attr_reader :parent

    # The +EnumDescriptorProto+ this +EnumDescriptor+ is wrapping.
    attr_reader :enum_descriptor_proto

    def initialize(parent, enum_descriptor_proto)
      @parent = parent
      @enum_descriptor_proto = enum_descriptor_proto
    end

    # The name of the enum
    def name; enum_descriptor_proto.name; end

    # The possible values of the enum
    def value; enum_descriptor_proto.value; end
    alias_method :values, :value

    # The +EnumOptions+ defined for this enum
    def options; enum_descriptor_proto.options; end

    include NamedChild
  end
end
