require "spec_helper"

describe ProtobufDescriptor::FileDescriptor do
  describe "#files" do
    it "has the right size" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor.files.size).to eq(1)
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

  describe "#java_package" do
    it "handles java_package option" do
      with_descriptor("service_rpc_test") do |descriptor|
        expect(descriptor.files[:wearabouts_pb].java_package).to eq("us.wearabouts.chatabout.proto")
      end
    end

    it "defaults to package if no java_package specified" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor.files[:single_file].java_package).to eq("porkbuns")
      end
    end
  end
end
