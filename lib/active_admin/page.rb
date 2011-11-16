module ActiveAdmin
  class Page
    attr_reader :namespace, :name, :page_configs

    def initialize(namespace, name, options)
      @namespace = namespace
      @name = name
      @options = options
      @page_configs = {}
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

    def underscored_resource_name
      name.gsub(' ', '').underscore
    end

    # From Naming.
    def camelized_resource_name
      underscored_resource_name.camelize
    end

    # From Resource.
    def controller_name
      [namespace.module_name, camelized_resource_name + "Controller"].compact.join('::')
    end

    # From Resource.
    def controller
      @controller ||= controller_name.constantize
    end

    # From Resource.
    def route_prefix
      namespace.module_name.try(:underscore)
    end

    # From Resource.
    def route_collection_path
      route = [route_prefix, controller.resources_configuration[:self][:route_collection_name]]

      if controller.resources_configuration[:self][:route_collection_name] ==
          controller.resources_configuration[:self][:route_instance_name]
        route << "index"
      end

      route << 'path'
      route.compact.join('_').to_sym
    end

    def comments?
      false
    end

    # Overwrite Resource::ActionItems
    def action_items_for(action)
      []
    end

    def skip_sidebar?
      true
    end

    def sidebar_sections_for(action)
      []
    end
  end
end
