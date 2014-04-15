require "protobuf_descriptor/enum_descriptor"
require "protobuf_descriptor/message_descriptor"
require "protobuf_descriptor/service_descriptor"

require "active_support"
require "active_support/core_ext/object/blank"

class ProtobufDescriptor
  class FileDescriptor
    attr_accessor :file_descriptor_set, :file_descriptor_proto
    attr_reader :message_type, :enum_type, :service

    def initialize(file_descriptor_set, file_descriptor_proto)
      # This is basically a parent pointer.
      @file_descriptor_set = file_descriptor_set
      @file_descriptor_proto = file_descriptor_proto

      @message_type = ProtobufDescriptor::NamedCollection.new(
          file_descriptor_proto.message_type.map { |m|
            ProtobufDescriptor::MessageDescriptor.new(self, m)
          })
      @enum_type = ProtobufDescriptor::NamedCollection.new(
          file_descriptor_proto.enum_type.map { |m|
            ProtobufDescriptor::EnumDescriptor.new(self, m)
          })
      @service = ProtobufDescriptor::NamedCollection.new(
          file_descriptor_proto.service.map { |m|
            ProtobufDescriptor::ServiceDescriptor.new(self, m)
          })
    end

    alias_method :message_types, :message_type
    alias_method :enum_types, :enum_type
    alias_method :services, :service

    def name
      file_descriptor_proto.name
    end

    def package
      file_descriptor_proto.package
    end

    def java_package
      if file_descriptor_proto.has_field?(:options) && file_descriptor_proto.options.java_package.present?
        return file_descriptor_proto.options.java_package
      else
        return file_descriptor_proto.package
      end
    end
  end
end
