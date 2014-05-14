class ProtobufDescriptor
  # Describes an enum type.
  #
  # See {+EnumValueDescriptorProto+}[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#180]
  class EnumValueDescriptor
    include ProtobufDescriptor::HasParent

    # The containing {ProtobufDescriptor::EnumDescriptor} that this is a value
    # for.
    attr_reader :parent

    # The +EnumValueDescriptorProto+ this +EnumValueDescriptor+ is wrapping.
    attr_reader :enum_value_descriptor_proto

    def initialize(parent, enum_value_descriptor_proto)
      @parent = parent
      @enum_value_descriptor_proto = enum_value_descriptor_proto
    end

    # The name of the enum value
    def name; enum_value_descriptor_proto.name; end

    # The number mapped to the enum value
    def number; enum_value_descriptor_proto.number; end

    # The +EnumValueOptions+ defined for this enum
    def options; enum_value_descriptor_proto.options; end
  end
end
