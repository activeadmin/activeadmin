module ActiveAdmin
  class Page < Config
    attr_reader :name

    def initialize(namespace, name, options)
      @namespace = namespace
      @name = name
      @options = options
    end

    # plural_resource_name is singular
    def plural_resource_name
      name
    end

    # Overwrite Naming defaults as they require a resource object.
    # @todo Refactor Naming to remove the dependency with Resources
    def resource_name
      name
    end

    # Overwrite Naming defaults as they require a resource object.
    # @todo Refactor Naming to remove the dependency with Resources
    def underscored_resource_name
      resource_name.underscore
    end
  end
end
