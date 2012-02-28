module ActiveAdmin

  class ResourceMismatchError < StandardError; end

  # Holds on to a collection of Resources. Is an Enumerable object
  # so it has some Array like qualities.
  #
  # Adding a resource assumes that the object responds to #resource_name
  class ResourceCollection
    include Enumerable

    def initialize
      @resource_hash = {}
    end

    # Add a new resource to the collection. If the resource_name already
    # exists, the exiting resource is returned.
    #
    # @param [Resource, Page] resource The resource to add to the collection
    #
    # @returns [Resource, Page] Either the existing resource or the new one
    def add(resource)
      if has_key?(resource.resource_name)
        existing_resource = find_by_key(resource.resource_name)
        ensure_resource_classes_match!(existing_resource, resource)
        existing_resource
      else
        @resource_hash[resource.resource_name] = resource
      end
    end

    # @returns [Array] An array of all the resources
    def resources
      @resource_hash.values
    end

    # For enumerable
    def each(&block)
      @resource_hash.values.each(&block)
    end

    # @returns [Array] An array of all the keys registered in the collection
    def keys
      @resource_hash.keys
    end

    # @returns [Boolean] If the key has been registered in the collection
    def has_key?(resource_name)
      @resource_hash.has_key?(resource_name)
    end

    # Finds a resource by a given key
    def find_by_key(resource_name)
      @resource_hash[resource_name]
    end

    # Finds a resource based on it's class. Looks up the class Heirarchy if its
    # a subclass of an Active Record class (ie: implementes base_class)
    def find_by_resource_class(resource_class)
      resource_class_name = resource_class.to_s
      match = resources_with_a_resource_class.find{|r| r.resource_class.to_s == resource_class_name }
      return match if match

      if resource_class.respond_to?(:base_class)
        base_class_name = resource_class.base_class.to_s
        resources_with_a_resource_class.find{|r| r.resource_class.to_s == base_class_name }
      else
        nil
      end
    end

    private

    def resources_with_a_resource_class
      select{|resource| resource.respond_to?(:resource_class) }
    end

    def ensure_resource_classes_match!(existing_resource, resource)
      return unless existing_resource.respond_to?(:resource_class) && resource.respond_to?(:resource_class)

      if existing_resource.resource_class != resource.resource_class
        raise ActiveAdmin::ResourceMismatchError, 
          "Tried to register #{resource.resource_class} as #{resource.resource_name} but already registered to #{existing_resource.resource_class}"
      end
    end

  end
end
