require "protobuf_descriptor/named_collection"
require "protobuf_descriptor/has_parent"

require "active_support"
require "active_support/core_ext/module/delegation"

class ProtobufDescriptor
  class ServiceDescriptor
    class MethodDescriptor
      attr_accessor :parent, :method_descriptor_proto

      def initialize(parent, method_descriptor_proto)
        @parent = parent
        @method_descriptor_proto = method_descriptor_proto
      end

      delegate :name, :options, to: :method_descriptor_proto

      include ProtobufDescriptor::HasParent

      def input_type_name
        method_descriptor_proto.input_type
      end

      def output_type_name
        method_descriptor_proto.output_type
      end

      def resolve_input_type
        protobuf_descriptor.resolve_type_name(input_type_name, file_descriptor)
      end

      def resolve_output_type
        protobuf_descriptor.resolve_type_name(output_type_name, file_descriptor)
      end
    end

    attr_accessor :parent, :service_descriptor_proto
    attr_reader :method

    def initialize(parent, service_descriptor_proto)
      @parent = parent
      @service_descriptor_proto = service_descriptor_proto
      @method = ProtobufDescriptor::NamedCollection.new(
          service_descriptor_proto.method.map { |m|
              ProtobufDescriptor::ServiceDescriptor::MethodDescriptor.new(self, m)
          })
    end

    delegate :name, :options, to: :service_descriptor_proto

    alias_method :methods, :method
  end
end
