require "spec_helper"

describe ProtobufDescriptor::MessageDescriptor::FieldDescriptor do
  describe "#type_name" do
    it "is sane" do
      with_descriptor("single_file_test") do |descriptor|
        message_descriptor = descriptor[:single_file].messages[:FieldOptions]
        field_descriptor = message_descriptor.fields[:ctype]

        expect(field_descriptor.type_name).to eq(".porkbuns.FieldOptions.CType")
        expect(field_descriptor.field_type).to eq(Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM)
      end
    end
  end
end
