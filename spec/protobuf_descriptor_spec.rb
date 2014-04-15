require "spec_helper"

describe ProtobufDescriptor do
  it "should have a VERSION constant" do
    expect(ProtobufDescriptor::VERSION).not_to be_empty
  end

  describe "Deserialization" do
    describe "#load" do
      it "should load the file" do
        with_descriptor_file("single_file_test") do |f|

          descriptor = ProtobufDescriptor.load(f.path)

          expect(descriptor.files).to have(1).item
        end
      end
    end

    describe "#decode_from" do
      it "should load the file" do
        with_descriptor_file("single_file_test") do |f|

          descriptor = ProtobufDescriptor.decode_from(f)

          expect(descriptor.files).to have(1).item
        end
      end
    end

    describe "#decode" do
      it "should load the file" do
        with_descriptor_file("single_file_test") do |f|

          descriptor = ProtobufDescriptor.decode(f.read)

          expect(descriptor.files).to have(1).item
        end
      end
    end
  end
end
