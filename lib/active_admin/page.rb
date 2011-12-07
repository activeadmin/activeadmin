module ActiveAdmin
  # Page is the primary data storage for page configuration in Active Admin
  #
  # When you register a page (ActiveAdmin.page "Status") you are actually creating
  # a new Page instance within the given Namespace.
  #
  # The instance of the current page is available in PageController and views
  # by calling the #active_admin_config method.
  #
  class Page

    # The namespace this config belongs to
    attr_reader :namespace

    # The name of the page
    attr_reader :name

    module Base
      def initialize(namespace, name, options)
        @namespace = namespace
        @name = name
        @options = options
      end
    end

    include Base
    include Resource::Controllers
    include Resource::PagePresenters
    include Resource::Sidebars
    include Resource::ActionItems
    include Resource::Menu
    include Resource::Naming

    # plural_resource_name is singular
    def plural_resource_name
      name
    end

    def resource_name
      name
    end

    def belongs_to?
      false
    end

    def add_default_action_items
    end

    def add_default_sidebar_sections
    end

  end
end
