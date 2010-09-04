module ActiveAdmin
  class Resource

    attr_reader :namespace, :resource, :page_configs, :member_actions, :collection_actions,
                :parent_menu_item_name
    attr_accessor :resource_name, :sort_order, :scope_to, :scope_to_association_method,
                  :belongs_to

    def initialize(namespace, resource, options = {})
      @namespace = namespace
      @resource = resource
      @options = default_options.merge(options)
      @sort_order = @options[:sort_order]
      @page_configs = {}
      @member_actions, @collection_actions = [], []
    end

    # An underscored safe representation internally for this resource
    def underscored_resource_name
      @underscored_resource_name ||= if @options[:as]
        @options[:as].gsub(' ', '').underscore.singularize
      else
        resource.name.gsub('::','').underscore
      end
    end

    # A camelized safe representation for this resource
    def camelized_resource_name
      underscored_resource_name.camelize
    end

    # Returns the name to call this resource
    def resource_name
      @resource_name ||= underscored_resource_name.titleize
    end

    # Returns the plural version of this resource
    def plural_resource_name
      @plural_resource_name ||= resource_name.pluralize
    end

    # Returns a properly formatted controller name for this
    # resource within its namespace
    def controller_name
      [namespace.module_name, camelized_resource_name.pluralize + "Controller"].compact.join('::')
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

    # Set the menu options
    def menu(options = {})
      @parent_menu_item_name = options[:parent]
    end

    # Returns the name to be displayed in the menu for this resource
    def menu_item_name
      @menu_item_name ||= plural_resource_name
    end

    def clear_member_actions!
      @member_actions = []
    end

    def clear_collection_actions!
      @collection_actions = []
    end

    # Returns the name of the controller class for this resource
    def dashboard_controller_name
      [namespace.module_name, "DashboardController"].compact.join("::")
    end

    # Do we belong to another resource
    def belongs_to?
      !belongs_to.nil?
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
