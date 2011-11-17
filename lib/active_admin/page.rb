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

    def resource_name
      name
    end
  end
end
