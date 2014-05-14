class ProtobufDescriptor
  # Mixin module to make accessing ancestors easier.
  #
  # Also has a random method for computing the source code info path (as well as
  # methods that rely on it to do things like grab comments and the like.)
  #
  # Classes that include this module must respond_to `parent`, in addition their
  # parent include `HasChildren`
  module HasParent
    def file_descriptor
      p = self.parent
      while p.class.name != "ProtobufDescriptor::FileDescriptor"
        p = p.parent
      end
      return p
    end

    def protobuf_descriptor
      p = self.parent
      while p.class.name != "ProtobufDescriptor"
        p = p.parent
      end
      return p
    end
  end
end
