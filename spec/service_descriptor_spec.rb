require "spec_helper"

describe ProtobufDescriptor::ServiceDescriptor do
  describe "#methods" do
    it "has right size" do
      with_descriptor("service_rpc_test") do |descriptor|
        service_descriptor = descriptor["wearabouts_api/user"].services[:UserService]
        expect(service_descriptor).to be_a(ProtobufDescriptor::ServiceDescriptor)
        expect(service_descriptor.methods).to have(3).items
      end
    end
  end
end
