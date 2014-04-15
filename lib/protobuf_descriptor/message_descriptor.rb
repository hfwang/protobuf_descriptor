require "protobuf_descriptor/enum_descriptor"
require "protobuf_descriptor/named_collection"

require "active_support"
require "active_support/core_ext/module/delegation"

class ProtobufDescriptor
  class MessageDescriptor
    attr_accessor :parent, :message_descriptor_proto
    attr_reader :nested_type, :enum_type

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
    end

    delegate :name, :field, :extension, :extension_range, :options, to: :message_descriptor_proto

    alias_method :fields, :field
    alias_method :extensions, :extension
    alias_method :nested_types, :nested_type
    alias_method :enum_types, :enum_type
    alias_method :extension_ranges, :extension_range
  end
end
