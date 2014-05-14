require "spec_helper"

describe "source_code_info" do
  let(:descriptor) { load_descriptor("source_info.srcinfo") }
  let(:no_info_descriptor) { load_descriptor("source_info") }

  describe "with no source info" do
    it "ProtobufDescriptor#has_source_code_info? returns false" do
      expect(no_info_descriptor.has_source_code_info?).to eq(false)
    end

    it "ProtobufDescriptor::FileDescriptor#has_source_code_info? returns false" do
      expect(no_info_descriptor.files.first.has_source_code_info?).to eq(false)
    end
  end

  it "ProtobufDescriptor#has_source_code_info? returns true" do
    expect(descriptor.has_source_code_info?).to eq(true)
  end

  it "ProtobufDescriptor::FileDescriptor#has_source_code_info? returns true" do
    expect(descriptor.files.first.has_source_code_info?).to eq(true)
  end

  it "ProtobufDescriptor::FileDescriptor#compute_source_code_info_path" do
    file = descriptor["foo"]

    expect(file.message_types.first.compute_source_code_info_path).to eq([4, 0])
    expect(descriptor.resolve_type_name(".foo.Bar").compute_source_code_info_path).to eq([4, 0])
    expect(file.enum_types.first.compute_source_code_info_path).to eq([5, 0])
    expect(file.services.first.compute_source_code_info_path).to eq([6, 0])
  end

  it "ProtobufDescriptor::FieldDescriptor#compute_source_code_info_path" do
    file = descriptor["foo"]

    expect(descriptor.resolve_type_name(".foo.Bar").fields[0].compute_source_code_info_path).to eq([4, 0, 2, 0])
    expect(descriptor.resolve_type_name(".foo.Bar.NestedBar").compute_source_code_info_path).to eq([4, 0, 3, 0])
    expect(descriptor.resolve_type_name(".foo.Bar.NestedEnum").compute_source_code_info_path).to eq([4, 0, 4, 0])
  end

  it "ProtobufDescriptor::HasParent#leading_comments" do
    expect(descriptor.resolve_type_name(".foo.Bar").leading_comments.strip).to eq("Test message for Bar")
    expect(descriptor.resolve_type_name(".foo.Bar").fields["bar"].leading_comments.strip).to eq("Comment attached to bar.")
    expect(descriptor.resolve_type_name(".foo.Bar").fields["grault"].leading_comments.strip).to eq("Block comment attached to\n grault.")
    expect(descriptor.resolve_type_name(".foo.FooService").leading_comments.strip).to eq("Comment for FooService")
    expect(descriptor.resolve_type_name(".foo.FooService").methods["Baz"].leading_comments.strip).to eq("Comment for Baz\n Maybe comments on return types.")
    expect(descriptor.resolve_type_name(".foo.BaseEnum").leading_comments.strip).to eq("Comment for BaseEnum")
  end

  it "ProtobufDescriptor::HasParent#trailing_comments" do
    expect(descriptor.resolve_type_name(".foo.Bar").fields["foo"].trailing_comments).to eq(" Comment attached to foo.\n")
  end
end
