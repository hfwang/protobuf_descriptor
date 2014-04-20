require "protobuf_descriptor/enum_descriptor"
require "protobuf_descriptor/named_child"
require "protobuf_descriptor/named_collection"

require "active_support"
require "active_support/core_ext/module/delegation"

class ProtobufDescriptor
  class MessageDescriptor
    class FieldDescriptor
      attr_accessor :parent, :field_descriptor_proto

      def initialize(parent, field_descriptor_proto)
        @parent = parent
        @field_descriptor_proto = field_descriptor_proto
      end

      delegate :name, :number, :label, :type_name, :extendee,
               :default_value, :options, to: :field_descriptor_proto

      def field_type
        field_descriptor_proto.type
      end
    end

    attr_accessor :parent, :message_descriptor_proto
    attr_reader :nested_type, :enum_type, :field

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
              ProtobufDescriptor::MessageDescriptor::FieldDescriptor.new(self, m)
          })
    end

    delegate :name, :extension, :extension_range, :options, to: :message_descriptor_proto

    alias_method :fields, :field
    alias_method :extensions, :extension
    alias_method :nested_types, :nested_type
    alias_method :messages, :nested_type
    alias_method :enum_types, :enum_type
    alias_method :enums, :enum_type
    alias_method :extension_ranges, :extension_range

    include NamedChild

    def children
      @children ||= ProtobufDescriptor::NamedCollection.new(
          @nested_type.collection + @enum_type.collection)
    end
  end
end
