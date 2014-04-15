class ProtobufDescriptor
  # A mixin module that adds tasty fully qualified name methods to objects that
  # have a name and a parent.
  module NamedChild
    def fully_qualified_name
      return "#{parent.fully_qualified_name}.#{self.name}"
    end

    def fully_qualified_java_name
      return "#{parent.fully_qualified_java_name}.#{self.name}"
    end

    def fully_qualified_wire_name
      return "#{parent.fully_qualified_wire_name}.#{self.name}"
    end

    def fully_qualified_ruby_name
      return "#{parent.fully_qualified_ruby_name}::#{self.name}"
    end
  end
end
