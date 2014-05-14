class ProtobufDescriptor
  # Describes a field within a message.
  #
  # See FieldDescriptorProto[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#103]
  class FieldDescriptor
    include ProtobufDescriptor::HasParent

    # The parent {ProtobufDescriptor::MessageDescriptor}
    attr_reader :parent
    # The +FieldDescriptorProto+ this +FieldDescriptor+ is wrapping.
    attr_reader :field_descriptor_proto

    def initialize(parent, field_descriptor_proto)
      @parent = parent
      @field_descriptor_proto = field_descriptor_proto
    end

    # The +FieldOptions+ for this field
    def options
      field_descriptor_proto.options
    end

    # Default value for this field.
    # * For numeric types, contains the original text representation of the
    #   value.
    # * For booleans, "true" or "false".
    # * For strings, contains the default text contents (not escaped in any
    #   way).
    # * For bytes, contains the C escaped value.  All bytes >= 128 are
    #   escaped.
    def default_value
      field_descriptor_proto.default_value
    end

    # For extensions, this is the name of the type being extended.  It is
    # resolved in the same manner as type_name.
    def extendee
      field_descriptor_proto.extendee
    end

    # For message and enum types, this is the name of the type.  If the name
    # starts with a '.', it is fully-qualified.  Otherwise, C++-like scoping
    # rules are used to find the type (i.e. first the nested types within this
    # message are searched, then within the parent, on up to the root
    # namespace).
    #
    # Note: the protocol buffer compiler always emits the fully qualified name!
    def type_name
      field_descriptor_proto.type_name
    end

    # Whether the field is optional/required/repeated.
    def label
      field_descriptor_proto.label
    end

    # The tag number of this field.
    def number
      field_descriptor_proto.number
    end

    # The name of this field.
    def name
      field_descriptor_proto.name
    end

    # If type_name is set, this need not be set.  If both this and type_name
    # are set, this must be either TYPE_ENUM or TYPE_MESSAGE.
    def field_type
      field_descriptor_proto.type
    end

    # Resolves the field's +type_name+, returning the
    # {ProtobufDescriptor::MessageDescriptor} or
    # {ProtobufDescriptor::EnumDescriptor} that this field will represent.
    def resolve_type
      protobuf_descriptor.resolve_type_name(self.type_name, self.parent)
    end
  end
end
