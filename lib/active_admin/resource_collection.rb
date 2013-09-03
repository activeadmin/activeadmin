module ActiveAdmin
  # This is a container for resources, which acts much like a Hash.
  # It's assumed that an added resource responds to `resource_name`.
  class ResourceCollection
    include Enumerable
    extend Forwardable
    def_delegators :@resources, :empty?, :has_key?, :keys, :values, :[]=, :[]

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

    # Find a resource by resource_name, resource_class, or class's base_class.
    #
    # @param [Class, String] name_or_class Class or name to find a resource
    #                        (e.g. Category or "Publisher")
    #
    # @returns [ActiveAdmin::Resource, nil]
    def find_matching_resource(name_or_class)
      find_by_resource_name(name_or_class) || find_by_resource_class(name_or_class) || find_by_resource_base_class(name_or_class)
    end

    private

    def find_by_resource_name(klass)
      find do |resource|
        resource.resource_name.to_s == klass.to_s
      end
    end

    def find_by_resource_class(klass)
      find do |resource|
        resource.resource_class.to_s == klass.to_s
      end
    end

    def find_by_resource_base_class(klass)
      if klass.respond_to? :base_class
        base_class = klass.base_class

        find do |resource|
          resource.resource_class.to_s == base_class.to_s
        end
      end
    end

    def find(&block)
      real_resources.detect &block
    end

    # REFACTOR: ResourceCollection currently stores Resource and Page objects. That doesn't
    # make sense, because by definition a ResourceCollection is a collection of resources.
    def real_resources
      select{ |r| r.respond_to? :resource_class }
    end

  end
end
