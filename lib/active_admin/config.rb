module ActiveAdmin
  class Config; end
end

require 'active_admin/config/naming'
require 'active_admin/config/menu'

module ActiveAdmin
  class Config
    # The namespace this config belongs to
    attr_reader :namespace

    # A hash of page configurations for the controller indexed by action name
    def page_configs
      @page_configs ||= {}
    end

    # Returns a properly formatted controller name for this
    # config within its namespace
    def controller_name
      [namespace.module_name, plural_underscored_resource_name.camelize + "Controller"].compact.join('::')
    end

    # Returns the controller for this config
    def controller
      @controller ||= controller_name.constantize
    end

    # Returns the routes prefix for this config
    def route_prefix
      namespace.module_name.try(:underscore)
    end

    # Returns a symbol for the route to use to get to the
    # collection of this resource
    def route_collection_path
      route = [route_prefix, controller.resources_configuration[:self][:route_collection_name]]

      if controller.resources_configuration[:self][:route_collection_name] ==
          controller.resources_configuration[:self][:route_instance_name]
        route << "index"
      end

      route << 'path'
      route.compact.join('_').to_sym
    end

    include Menu
    include Naming

    def belongs_to?
      false
    end

    def comments?
      false
    end

    def action_items?
      !!@action_items && @action_items.any?
    end

    def sidebar_sections?
      !!@sidebar_sections && @sidebar_sections.any?
    end
  end
end
