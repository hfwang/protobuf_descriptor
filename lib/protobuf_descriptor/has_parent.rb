class ProtobufDescriptor
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
