class ProtobufDescriptor
  # Describes a service.
  #
  # See ServiceDescriptorProto[https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#188]
  class ServiceDescriptor
    include ProtobufDescriptor::HasParent
    include ProtobufDescriptor::NamedChild
    include ProtobufDescriptor::HasChildren

    # The parent {ProtobufDescriptor::FileDescriptor}
    attr_reader :parent

    # The +ServiceDescriptorProto+ this +ServiceDescriptor+ is wrapping
    attr_reader :service_descriptor_proto

    # Set of methods contained within this service, as a NamedCollection of
    # {ProtobufDescriptor::ServiceDescriptor::MethodDescriptor MethodDescriptors}
    attr_reader :method
    alias_method :methods, :method

    # Field index is hard-coded since these are a bit annoying to grab
    # consistently with the different protocol buffer implementations.
    self.register_children(:method, 2)

    def initialize(parent, service_descriptor_proto)
      @parent = parent
      @service_descriptor_proto = service_descriptor_proto
      @method = ProtobufDescriptor::NamedCollection.new(
          service_descriptor_proto.method.map { |m|
              ProtobufDescriptor::MethodDescriptor.new(self, m)
          })
    end

    # The name of the service
    def name; service_descriptor_proto.name; end

    # The +ServiceOptions+ for this service.
    def options; service_descriptor_proto.options; end

  end
end
