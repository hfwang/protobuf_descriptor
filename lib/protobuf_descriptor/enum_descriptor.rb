require "active_support"
require "protobuf_descriptor/named_child"
require "active_support/core_ext/module/delegation"

class ProtobufDescriptor
  class EnumDescriptor
    attr_accessor :parent, :enum_descriptor_proto

    def initialize(parent, enum_descriptor_proto)
      @parent = parent
      @enum_descriptor_proto = enum_descriptor_proto
    end

    delegate :name, :value, :options, to: :enum_descriptor_proto
    alias_method :values, :value

    include NamedChild
  end
end
