require "spec_helper"
require "tmpdir"

describe "ProtocJavaCompiler" do
  # Compile the contents of the generator_tests proto dir, and then assert
  # everything is where it should be.
  it "computes fully-qualified class names correctly" do
    with_descriptor("generator_test") do |descriptor|
      generated_classes = ghetto_parse_java_package(find_generated_files("generator_test", :java))

      children = descriptor.all_descendants.map { |child|
        [child.name, child.fully_qualified_java_name]
      }
      expect(children).to contain_exactly(*generated_classes.to_a)
    end
  end
end
