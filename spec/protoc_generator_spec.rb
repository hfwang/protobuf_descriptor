require "spec_helper"
require "tmpdir"

describe "ProtocJavaCompiler" do
  # Compile the contents of the generator_tests proto dir, and then assert
  # everything is where it should be.
  it "computes fully-qualified class names correctly" do
    with_descriptor("generator_test") do |descriptor|
      generated_classes = ghetto_parse_java_package(find_generated_files("generator_test", :java))

      children = descriptor.all_descendants

      expect(children).to have(generated_classes.size).items
      children.each do |child|
        expect(child.fully_qualified_java_name).to eq(generated_classes[child.name])
      end
    end
  end
end
