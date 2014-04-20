require "spec_helper"

describe ProtobufDescriptor::ServiceDescriptor::MethodDescriptor do
  it "is sane" do
    with_descriptor("service_rpc_test") do |descriptor|
      file_descriptor = descriptor["wearabouts_api/user"]
      service_descriptor = file_descriptor.services[:UserService]
      method_descriptor = service_descriptor.methods[:Authenticate]

      expect(method_descriptor.input_type_name).to eq(".WearaboutsApi.User.AuthenticateRequest")
      expect(method_descriptor.output_type_name).to eq(".WearaboutsApi.User.AuthenticateResponse")

      expect(method_descriptor.resolve_input_type).to eq(file_descriptor.messages[:AuthenticateRequest])
      expect(method_descriptor.resolve_output_type).to eq(file_descriptor.messages[:AuthenticateResponse])
    end
  end
end
