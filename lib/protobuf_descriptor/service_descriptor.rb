require "active_support"
require "active_support/core_ext/module/delegation"

class ProtobufDescriptor
  class ServiceDescriptor
    attr_accessor :parent, :service_descriptor_proto

    def initialize(parent, service_descriptor_proto)
      @parent = parent
      @service_descriptor_proto = service_descriptor_proto
    end

    delegate :name, :method, :options, to: :service_descriptor_proto
    alias_method :methods, :method
  end
end
