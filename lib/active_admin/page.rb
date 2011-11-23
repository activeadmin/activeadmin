module ActiveAdmin
  # Page is the primary data storage for page configuration in Active Admin
  #
  # When you register a page (ActiveAdmin.page "Status") you are actually creating
  # a new Page instance within the given Namespace.
  #
  # The instance of the current page is available in PageController and views
  # by calling the #active_admin_config method.
  #
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
