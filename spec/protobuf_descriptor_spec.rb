require "spec_helper"

describe ProtobufDescriptor do
  it "should have a VERSION constant" do
    expect(ProtobufDescriptor::VERSION).not_to be_empty
  end

  describe "#resolve_type_name" do
    it "should handle fully qualified names" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor.resolve_type_name(".porkbuns.UnnestedEnum")).to eq(descriptor[:single_file].enums[:UnnestedEnum])
        expect(descriptor.resolve_type_name(".porkbuns.FieldOptions")).to eq(descriptor[:single_file].messages[:FieldOptions])
        expect(descriptor.resolve_type_name(".porkbuns.FieldOptions.CType")).to eq(descriptor[:single_file].messages[:FieldOptions].enums[:CType])
      end
    end

    it "should handle relative names" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor.resolve_type_name("UnnestedEnum", ".porkbuns")).to eq(descriptor[:single_file].enums[:UnnestedEnum])
        expect(descriptor.resolve_type_name("FieldOptions", ".porkbuns")).to eq(descriptor[:single_file].messages[:FieldOptions])
        expect(descriptor.resolve_type_name("CType", ".porkbuns.FieldOptions")).to eq(descriptor[:single_file].messages[:FieldOptions].enums[:CType])
      end
    end

    it "should allow the relative_to argument to be a descriptor object" do
      with_descriptor("single_file_test") do |descriptor|
        file_descriptor = descriptor[:single_file]
        expect(descriptor.resolve_type_name("UnnestedEnum", file_descriptor)).to eq(file_descriptor.enums[:UnnestedEnum])
        expect(descriptor.resolve_type_name("FieldOptions", file_descriptor)).to eq(file_descriptor.messages[:FieldOptions])
        expect(descriptor.resolve_type_name("CType", file_descriptor.messages[:FieldOptions])).to eq(file_descriptor.messages[:FieldOptions].enums[:CType])
      end
    end

    it "should backtrack when using relative names" do
      with_descriptor("single_file_test") do |descriptor|
        expect(descriptor.resolve_type_name("UnnestedEnum", ".porkbuns.FieldOptions.CType")).to eq(descriptor[:single_file].enums[:UnnestedEnum])
      end
    end

    it "should handle fully qualified names for package-less proto files" do
      descriptor = load_descriptor("generator_test")
      expect(descriptor.resolve_type_name(".Mab")).to eq(descriptor[:no_package].messages[:Mab])
    end
  end

  describe "Deserialization" do
    describe "#load" do
      it "should load the file" do
        with_descriptor_file("single_file_test") do |f|

          descriptor = ProtobufDescriptor.load(f.path)

          expect(descriptor.files.size).to eq(1)
        end
      end
    end

    describe "#decode_from" do
      it "should load the file" do
        with_descriptor_file("single_file_test") do |f|

          descriptor = ProtobufDescriptor.decode_from(f)

          expect(descriptor.files.size).to eq(1)
        end
      end
    end

    describe "#decode" do
      it "should load the file" do
        with_descriptor_file("single_file_test") do |f|

          descriptor = ProtobufDescriptor.decode(f.read)

          expect(descriptor.files.size).to eq(1)
        end
      end
    end
  end
end
