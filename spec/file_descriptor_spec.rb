require "spec_helper"

describe ProtobufDescriptor::FileDescriptor do
  describe "#files" do
    it "has the right size" do
      with_descriptor("service_rpc_test") do |descriptor|
        expect(descriptor.files).to have(2).items
        expect(descriptor.files.size).to eq(2)
      end
    end

    describe "#[]" do
      it "handles numeric index" do
        with_descriptor("service_rpc_test") do |descriptor|
          expect(descriptor.files[0]).to eq(descriptor.files.first)
        end
      end

      it "handles lookup by basename" do
        with_descriptor("service_rpc_test") do |descriptor|
          expect(descriptor.files["wearabouts_api/user"].name).to eq("wearabouts_api/user.proto")
        end
      end

      it "handles lookup by filename" do
        with_descriptor("service_rpc_test") do |descriptor|
          expect(descriptor.files["wearabouts_api/user.proto"].name).to eq("wearabouts_api/user.proto")
        end
      end

      it "returns nil if not found" do
        with_descriptor("service_rpc_test") do |descriptor|
          expect(descriptor.files["wearabouts_api/userblah"]).to be_nil
        end
      end
    end
  end
end
