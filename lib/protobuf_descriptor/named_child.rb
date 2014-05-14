class ProtobufDescriptor
  # A mixin module that adds tasty fully qualified name methods to objects that
  # have a name and a parent.
  #
  # Classes including this module *must* respond_to `name` and `parent`
  module NamedChild
    def fully_qualified_name
      parent_name = parent.fully_qualified_name

      return ".#{self.name}" if parent_name == "."
      return "#{parent_name}.#{self.name}"
    end

    def fully_qualified_java_name
      parent_name = parent.fully_qualified_java_name

      return "#{self.name}" if parent_name == ""
      return "#{parent_name}.#{self.name}"
    end

    def fully_qualified_wire_name
      parent_name = parent.fully_qualified_wire_name

      return "#{self.name}" if parent_name == ""
      return "#{parent_name}.#{self.name}"
    end

    def fully_qualified_ruby_name
      parent_name = parent.fully_qualified_ruby_name

      return "::#{self.name}" if parent_name == "::"
      return "#{parent_name}::#{self.name}"
    end

    def inspect
      oid = (object_id << 1)
      return "#<%s:0x%x %s>" % [self.class, oid, self.fully_qualified_name]
    end
  end
end
