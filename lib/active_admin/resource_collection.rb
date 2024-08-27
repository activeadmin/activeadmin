# frozen_string_literal: true
module ActiveAdmin
  # This is a container for resources, which acts much like a Hash.
  # It's assumed that an added resource responds to `resource_name`.
  class ResourceCollection
    include Enumerable
    extend Forwardable
    def_delegators :@collection, :empty?, :has_key?, :keys, :values, :size

    def initialize
      @collection = {}
    end

    def add(resource)
      if match = @collection[resource.resource_name]
        raise_if_mismatched! match, resource
        match
      else
        @collection[resource.resource_name] = resource
      end
    end

    # Changes `each` to pass in the value, instead of both the key and value.
    def each(&block)
      values.each &block
    end

    def [](obj)
      @collection[obj] || find_resource(obj)
    end

    private

    # Finds a resource based on the resource name, resource class, or base class.
    def find_resource(obj)
      resources.detect do |r|
        r.resource_name.to_s == obj.to_s
      end || resources.detect do |r|
        r.resource_class.to_s == obj.to_s
      end ||
      if obj.respond_to? :base_class
        resources.detect { |r| r.resource_class.to_s == obj.base_class.to_s }
      end
    end

    def resources
      select { |r| r.class <= Resource } # can otherwise be a Page
    end

    def raise_if_mismatched!(existing, given)
      if existing.class != given.class
        raise IncorrectClass.new existing, given
      elsif given.class <= Resource && existing.resource_class != given.resource_class
        raise ConfigMismatch.new existing, given
      end
    end

    class IncorrectClass < StandardError
      def initialize(existing, given)
        super "You're trying to register #{given.resource_name} which is a #{given.class}, " +
              "but #{existing.resource_name}, a #{existing.class} has already claimed that name."
      end
    end

    class ConfigMismatch < StandardError
      def initialize(existing, given)
        super "You're trying to register #{given.resource_class} as #{given.resource_name}, " +
              "but the existing #{existing.class} config was built for #{existing.resource_class}!"
      end
    end

  end
end
