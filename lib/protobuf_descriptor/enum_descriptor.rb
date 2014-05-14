class ProtobufDescriptor
  # Describes an enum type.
  #
  # See {+EnumDescriptorProto+}[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#171]
  class EnumDescriptor
    include ProtobufDescriptor::HasParent
    include ProtobufDescriptor::NamedChild
    include ProtobufDescriptor::HasChildren

    # The containing {ProtobufDescriptor::FileDescriptor} or
    # {ProtobufDescriptor::MessageDescriptor} that defines this enum.
    attr_reader :parent

    # The +EnumDescriptorProto+ this +EnumDescriptor+ is wrapping.
    attr_reader :enum_descriptor_proto

    # List of the enum values for this `EnumDescriptor` as a `NamedCollection`
    # of {ProtobufDescriptor::EnumValueDescriptor}
    attr_reader :value
    alias_method :values, :value

    register_children(:value, 2)

    def initialize(parent, enum_descriptor_proto)
      @parent = parent
      @enum_descriptor_proto = enum_descriptor_proto

      @value = ProtobufDescriptor::NamedCollection.new(
          enum_descriptor_proto.value.map { |m|
            ProtobufDescriptor::EnumValueDescriptor.new(self, m)
          })
    end

    # The name of the enum
    def name; enum_descriptor_proto.name; end

    # The +EnumOptions+ defined for this enum
    def options; enum_descriptor_proto.options; end
  end
end
