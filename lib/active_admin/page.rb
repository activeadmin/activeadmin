module ActiveAdmin
  class Page < Config
    attr_reader :namespace, :name, :page_configs

    def initialize(namespace, name, options)
      @namespace = namespace
      @name = name
      @options = options
      @page_configs = {}
    end

    # Returns a properly formatted controller name for this
    # resource within its namespace
    def controller_name
      [namespace.module_name, camelized_resource_name + "Controller"].compact.join('::')
    end

    # For Menu#include_in_menu?
    def belongs_to?
      false
    end

    # For Menu#menu_item_name
    def plural_resource_name
      name
    end

    include ActiveAdmin::Resource::Menu

    # ############## Naming ###################
    def underscored_resource_name
      name.gsub(' ', '').underscore
    end

    # From Naming.
    def camelized_resource_name
      underscored_resource_name.camelize
    end
    # ############## Naming ###################

    # ############# From Resource.
    def comments?
      false
    end

    # From Resource::ActionItems
    def action_items_for(action)
      []
    end

    # From Resource::Sidebars
    def sidebar_sections_for(action)
      []
    end
  end
end
