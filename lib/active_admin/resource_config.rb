module ActiveAdmin
  class ResourceConfig

    attr_reader :resource, :page_configs, :member_actions
    attr_accessor :resource_name, :sort_order

    def initialize(resource, options = {})
      @resource = resource
      @options = default_options.merge(options)
      @resource_name = options[:as]
      @sort_order = @options[:sort_order]
      @page_configs = {}
      @member_actions = []
    end

    # Returns the namespace for the resource
    def namespace
      @options[:namespace]
    end

    # Returns the name to call this resource
    def resource_name
      @resource_name ||= resource.name.titleize
    end

    # Returns the plural version of this resource
    def plural_resource_name
      @plural_resource_name ||= resource_name.pluralize
    end

    # If the resource is namespaced, this returns a string
    # which represents the name of the ruby module.
    #
    # If the resource is not namespaced it returns nil
    def namespace_module_name
      return nil unless namespace
      namespace.to_s.camelcase
    end

    # Returns a properly formatted controller name for this
    # resource within its namespace
    def controller_name
      [namespace_module_name, resource.name.pluralize + "Controller"].compact.join('::')
    end

    # Returns the controller for this resource
    def controller
      @controller ||= controller_name.constantize
    end

    # Returns the routes prefix for this resource
    def route_prefix
      controller.resources_configuration[:self][:route_prefix]
    end

    # Returns a symbol for the route to use to get to the
    # collection of this resource
    def route_collection_path
      [route_prefix, controller.resources_configuration[:self][:route_collection_name], 'path'].compact.join('_').to_sym
    end

    # Returns which menu to add the item to
    def menu_name
      namespace || :root
    end

    # Returns the name to be displayed in the menu for this resource
    def menu_item_name
      @menu_item_name ||= plural_resource_name
    end

    def clear_member_actions!
      @member_actions = []
    end

    private

    def default_options
      {
        :namespace  => ActiveAdmin.default_namespace,
        :sort_order => ActiveAdmin.default_sort_order,
      }
    end

  end
end
