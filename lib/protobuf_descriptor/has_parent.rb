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

    def compute_source_code_info_path
      path_component = parent.compute_source_code_info_path_component(self)
      parent_path = if parent.class.name == "ProtobufDescriptor::FileDescriptor"
                      []
                    else
                      parent.compute_source_code_info_path
                    end
      return parent_path + path_component
    end

    def source_code_info_locations
      raise "No source code info attached!" unless file_descriptor.has_source_code_info?

      source_code_info_path = compute_source_code_info_path
      return file_descriptor.source_code_info.location.select { |location|
        location.path == source_code_info_path
      }
    end

    def source_code_info_location
      return source_code_info_locations.first
    end

    def source_code_info_span
      return source_code_info_location.span
    end

    def leading_comments
      return source_code_info_location.leading_comments
    end

    def trailing_comments
      return source_code_info_location.trailing_comments
    end
  end
end
