require "spec_helper"

describe ProtobufDescriptor::MessageDescriptor do
  describe "#fully_qualified_name" do
    it "handles top-level messages" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor[:single_file].message_types[:FieldOptions].fully_qualified_name).to eq(".porkbuns.FieldOptions")
      end
    end

    it "handles nested messages" do
      with_descriptor("service_rpc_test") do |descriptor|
        expect(descriptor[:wearabouts_pb].message_types[:UserProto].nested_type[:UserDetails].fully_qualified_name).to eq(".WearaboutsPb.UserProto.UserDetails")
      end
    end
  end

  describe "#fully_qualified_java_name" do
    it "handles top-level messages" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor[:single_file].message_types[:FieldOptions].fully_qualified_java_name).to eq("porkbuns.SingleFile.FieldOptions")
      end
    end

    it "handles nested messages" do
      with_descriptor("service_rpc_test") do |descriptor|
        expect(descriptor[:wearabouts_pb].message_types[:UserProto].nested_type[:UserDetails].fully_qualified_java_name).to eq("us.wearabouts.chatabout.proto.WearaboutsPb.UserProto.UserDetails")
      end
    end

    it "handles java_outer_classname option" do
      with_descriptor("service_rpc_test") do |descriptor|
        expect(descriptor["wearabouts_api/outer_class_proto"].message_types[:Icon].fully_qualified_java_name).to eq("us.wearabouts.chatabout.outer.OuterClassName.Icon")
      end
    end

    it "handles java_multiple_files option" do
      with_descriptor("service_rpc_test") do |descriptor|
        expect(descriptor["wearabouts_api/multiple_files"].message_types[:Icon].fully_qualified_java_name).to eq("us.wearabouts.chatabout.multiple.Icon")
      end
    end
  end
end
