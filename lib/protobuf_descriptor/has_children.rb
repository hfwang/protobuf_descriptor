class ProtobufDescriptor
  # Mixin module to support classes with different "kinds" of children
  module HasChildren
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # To be called by the containing class, registers a set of children
      def register_children(children_method, child_kind_id)
        @registered_children ||= Hash.new { |h, k| h[k] = [] }

        @registered_children[child_kind_id] = children_method
      end

      def registered_children
        return @registered_children
      end
    end

    def named_children
      return @named_children if @named_children

      @named_children = NamedCollection.new([])

      self.class.registered_children.each do |id, method|
        collection = self.send(method)
        collection = collection.is_a?(NamedCollection) ? collection.collection : collection
        collection.each do |m|
          @named_children << m if m.is_a?(NamedChild)
        end
      end
      return @named_children
    end

    # Computes the "relative path" from this node to one of its direct children
    # according to the rules specified by
    # [descriptor.proto line 506](https://code.google.com/p/protobuf/source/browse/trunk/src/google/protobuf/descriptor.proto#506).
    def compute_source_code_info_path_component(child)
      self.class.registered_children.each do |kind_id, collection|
        idx = self.send(collection).find_index(child)
        if !idx.nil?
          return [kind_id, idx]
        end
      end
      raise "Could not find #{child} in #{self}"
    end
  end
end
