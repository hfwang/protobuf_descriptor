require "spec_helper"

describe ProtobufDescriptor::ServiceDescriptor::MethodDescriptor do
  it "is sane" do
    with_descriptor("service_rpc_test") do |descriptor|
      service_descriptor = descriptor["wearabouts_api/user"].services[:UserService]
      method_descriptor = service_descriptor.methods[:Authenticate]

      expect(method_descriptor.input_type_name).to eq(".WearaboutsApi.User.AuthenticateRequest")
      expect(method_descriptor.output_type_name).to eq(".WearaboutsApi.User.AuthenticateResponse")
    end
  end
end
