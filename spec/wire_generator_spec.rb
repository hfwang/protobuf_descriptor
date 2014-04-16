require "spec_helper"
require "tmpdir"

describe "WireCompiler" do
  # Compile the contents of the generator_tests proto dir, and then assert
  # everything is where it should be.
  it "computes fully-qualified class names correctly" do
    Dir.mktmpdir do |dir|
      # The following is to compile protos with wire, since its done as a
      # separate process:
      compile_wire_protobuf(source: "#{File.dirname(__FILE__)}/protos/generator_test/", destination: dir)
      generated_classes = ghetto_parse_java_package(dir)

      with_descriptor("generator_test") do |descriptor|
        children = descriptor.all_descendants

        children.each do |child|
          expect(child.fully_qualified_wire_name).to eq(generated_classes[child.name])
        end
      end
    end
  end
end
