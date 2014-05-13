class ProtobufDescriptor
  # Describes a service.
  #
  # See ServiceDescriptorProto[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#188]
  class ServiceDescriptor
    # Describes a method of a service.
    #
    # See MethodDescriptorProto[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#196]
    class MethodDescriptor
      # The parent {ProtobufDescriptor::ServiceDescriptor}
      attr_reader :parent

      # The +MethodDescriptorProto+ this +MethodDescriptor+ is wrapping
      attr_reader :method_descriptor_proto

      def initialize(parent, method_descriptor_proto)
        @parent = parent
        @method_descriptor_proto = method_descriptor_proto
      end

      include ProtobufDescriptor::HasParent

      # The name of the service method
      def name
        method_descriptor_proto.name
      end

      # The +MethodOptions+ for the service method
      def options
        method_descriptor_proto.options
      end

      # Input type name for the service method. This is resolved in the same way
      # as FieldDescriptorProto.type_name, but must refer to a message type.
      def input_type_name
        method_descriptor_proto.input_type
      end

      # Output type name for the service method. This is resolved in the same way
      # as FieldDescriptorProto.type_name, but must refer to a message type.
      def output_type_name
        method_descriptor_proto.output_type
      end

      # Resolves the method's +input_type_name+, returning the
      # {ProtobufDescriptor::MessageDescriptor} that this method receives.
      def resolve_input_type
        protobuf_descriptor.resolve_type_name(input_type_name, file_descriptor)
      end

      # Resolves the method's +output_type_name+, returning the
      # {ProtobufDescriptor::MessageDescriptor} that this method
      # returns.
      def resolve_output_type
        protobuf_descriptor.resolve_type_name(output_type_name, file_descriptor)
      end
    end

    # The parent {ProtobufDescriptor::FileDescriptor}
    attr_reader :parent

    # The +ServiceDescriptorProto+ this +ServiceDescriptor+ is wrapping
    attr_reader :service_descriptor_proto

    # Set of methods contained within this service, as a NamedCollection of
    # {ProtobufDescriptor::ServiceDescriptor::MethodDescriptor MethodDescriptors}
    attr_reader :method

    def initialize(parent, service_descriptor_proto)
      @parent = parent
      @service_descriptor_proto = service_descriptor_proto
      @method = ProtobufDescriptor::NamedCollection.new(
          service_descriptor_proto.method.map { |m|
              ProtobufDescriptor::ServiceDescriptor::MethodDescriptor.new(self, m)
          })
    end


    # The name of the service
    def name; service_descriptor_proto.name; end

    # The +ServiceOptions+ for this service.
    def options; service_descriptor_proto.options; end

    alias_method :methods, :method
  end
end
