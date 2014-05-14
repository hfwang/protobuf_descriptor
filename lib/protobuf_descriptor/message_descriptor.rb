class ProtobufDescriptor
  # Describes a message type.
  #
  # See DescriptorProto[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#84]
  class MessageDescriptor
    include ProtobufDescriptor::HasParent
    include ProtobufDescriptor::NamedChild
    include ProtobufDescriptor::HasChildren

    # The containing {ProtobufDescriptor::FileDescriptor}
    # or {ProtobufDescriptor::MessageDescriptor} that
    # defines this message.
    attr_reader :parent

    # The +MessageDescriptorProto+ this +MessageDescriptor+ is wrapping.
    attr_reader :message_descriptor_proto

    # The messages that are defined at the top level of this message, as a
    # NamedCollection of {ProtobufDescriptor::MessageDescriptor}
    attr_reader :nested_type
    alias_method :nested_types, :nested_type
    alias_method :messages, :nested_type

    # The enums that are defined at the top level of this message, as a
    # NamedCollection of {ProtobufDescriptor::EnumDescriptor}
    attr_reader :enum_type
    alias_method :enum_types, :enum_type
    alias_method :enums, :enum_type

    # The fields of this message, as a NamedCollection of
    # {ProtobufDescriptor::MessageDescriptor::FieldDescriptor}
    attr_reader :field
    alias_method :fields, :field

    # Field index is hard-coded since these are a bit annoying to grab
    # consistently with the different protocol buffer implementations.
    self.register_children(:field, 2)
    self.register_children(:nested_type, 3)
    self.register_children(:enum_type, 4)

    def initialize(parent, message_descriptor_proto)
      @parent = parent
      @message_descriptor_proto = message_descriptor_proto

      @nested_type = ProtobufDescriptor::NamedCollection.new(
          message_descriptor_proto.nested_type.map { |m|
              ProtobufDescriptor::MessageDescriptor.new(self, m)
          })

      @enum_type = ProtobufDescriptor::NamedCollection.new(
          message_descriptor_proto.enum_type.map { |m|
              ProtobufDescriptor::EnumDescriptor.new(self, m)
          })

      @field = ProtobufDescriptor::NamedCollection.new(
          message_descriptor_proto.field.map { |m|
              ProtobufDescriptor::FieldDescriptor.new(self, m)
          })
    end

    # The +MessageOptions+ defined for this message.
    def options
      message_descriptor_proto.options
    end

    # The extension ranges defined for this message
    def extension_range
      message_descriptor_proto.extension_range
    end
    alias_method :extension_ranges, :extension_range

    # The extensions defined for this message
    def extension
      message_descriptor_proto.extension
    end
    alias_method :extensions, :extension

    # The name of the message
    def name
      message_descriptor_proto.name
    end
  end
end
