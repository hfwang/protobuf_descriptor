require "spec_helper"

describe ProtobufDescriptor::EnumDescriptor do
  describe "#fully_qualified_name" do
    it "handles top-level enums" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor[:single_file].enum_types[:UnnestedEnum].fully_qualified_name).to eq(".porkbuns.UnnestedEnum")
      end
    end

    it "handles nested enums" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor[:single_file].message_types[:FieldOptions].enum_types[:CType].fully_qualified_name).to eq(".porkbuns.FieldOptions.CType")
      end
    end
  end

  describe "#fully_qualified_java_name" do
    it "handles top-level enums" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor[:single_file].enum_types[:UnnestedEnum].fully_qualified_java_name).to eq("porkbuns.SingleFile.UnnestedEnum")
      end
    end

    it "handles nested enums" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor[:single_file].message_types[:FieldOptions].enum_types[:CType].fully_qualified_java_name).to eq("porkbuns.SingleFile.FieldOptions.CType")
      end
    end

    it "handles java_outer_classname option" do
      with_descriptor("service_rpc_test") do |descriptor|
        name = descriptor["wearabouts_api/outer_class_proto"].enum_types[:IconEnum].fully_qualified_java_name
        expect(name).to eq("us.wearabouts.chatabout.outer.OuterClassName.IconEnum")
      end
    end

    it "handles java_multiple_files option" do
      with_descriptor("service_rpc_test") do |descriptor|
        name = descriptor["wearabouts_api/multiple_files"].enum_types[:IconEnum].fully_qualified_java_name
        expect(name).to eq("us.wearabouts.chatabout.multiple.IconEnum")
      end
    end
  end
end
