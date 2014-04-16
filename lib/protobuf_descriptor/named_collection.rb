require 'forwardable'

class ProtobufDescriptor
  # Array wrapper that also supports lookup by "name"
  #
  # By default all members must respond to name, but this behavior can be
  # overriden by passing a block in the initializer.
  class NamedCollection
    attr_accessor :collection, :matcher

    include Enumerable
    extend Forwardable

    def_delegators :@collection, :each, :<<, :size, :length

    def initialize(collection, &matcher)
      @collection = []
      collection.each { |c| @collection << c }

      if block_given?
        @matcher = matcher
      else
        @matcher = lambda { |name, member| return member.name == name }
      end
    end

    def [](index)
      if Fixnum === index
        return collection[index]
      else
        return find_by_name(index)
      end
    end

    def find_by_name(name)
      return collection.find { |member|
        matcher.call(name.to_s, member)
      }
    end

    def to_a
      return self.collection.to_a
    end
  end
end
