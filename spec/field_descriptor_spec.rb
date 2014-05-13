require "spec_helper"

describe ProtobufDescriptor::FieldDescriptor do
  describe "#type_name" do
    it "is sane" do
      with_descriptor("single_file_test") do |descriptor|
        message_descriptor = descriptor[:single_file].messages[:FieldOptions]
        field_descriptor = message_descriptor.fields[:ctype]

        expect(field_descriptor.field_type).to eq(Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM)
        expect(field_descriptor.type_name).to eq(".porkbuns.FieldOptions.CType")
      end
    end
  end

  it "#resolve_type resolves a field's type name" do
    with_descriptor("single_file_test") do |descriptor|
      message_descriptor = descriptor[:single_file].messages[:FieldOptions]
      field_descriptor = message_descriptor.fields[:ctype]

      expect(field_descriptor.resolve_type).to eq(message_descriptor.enums[:CType])
    end
  end
end
