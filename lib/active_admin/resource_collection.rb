module ActiveAdmin
  # This is a container for resources, which acts much like a Hash.
  # It's assumed that an added resource responds to `resource_name`.
  class ResourceCollection
    include Enumerable
    extend Forwardable
    def_delegators :@resources, :empty?, :has_key?, :keys, :values, :[]=

    def initialize
      @resources = {}
    end

    def add(resource)
      self[resource.resource_name] ||= resource
    end

    # Changes `each` to pass in the value, instead of both the key and value.
    def each(&block)
      values.each &block
    end

    # Finds a resource based on the resource name, the resource class, or the base class.
    def [](klass)
      if match = @resources[klass]
        match
      elsif match = real_resources.detect{ |r| r.resource_class.to_s == klass.to_s }
        match
      elsif klass.respond_to? :base_class
        real_resources.detect{ |r| r.resource_class.to_s == klass.base_class.to_s }
      end
    end

    private

    # REFACTOR: ResourceCollection currently stores Resource and Page objects. That doesn't
    # make sense, because by definition a ResourceCollection is a collection of resources.
    def real_resources
      select{ |r| r.respond_to? :resource_class }
    end

  end
end
