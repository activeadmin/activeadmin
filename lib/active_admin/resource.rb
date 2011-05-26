module ActiveAdmin

  # Resource is the primary data storage for resource configuration in Active Admin
  #
  # When you register a resource (ActiveAdmin.register Post) you are actually creating
  # a new Resource instance within the given Namespace.
  #
  # The instance of the current resource is available in ResourceController and views
  # by calling the #active_admin_config method.
  #
  class Resource

    # Event dispatched when a new resource is registered
    RegisterEvent = 'active_admin.resource.register'.freeze

    autoload :BelongsTo, 'active_admin/resource/belongs_to'

    # The namespace this resource belongs to
    attr_reader :namespace

    # The class this resource wraps. If you register the Post model, Resource#resource
    # will point to the Post class
    attr_reader :resource

    # A hash of page configurations for the controller indexed by action name
    attr_reader :page_configs

    # An array of member actions defined for this resource
    attr_reader :member_actions

    # An array of collection actions defined for this resource
    attr_reader :collection_actions

    # The titleized name to use for this resource
    attr_accessor :resource_name

    # The default sort order to use in the controller
    attr_accessor :sort_order

    # Scope this resource to an association in the controller
    attr_accessor :scope_to

    # If we're scoping resources, use this method on the parent to return the collection
    attr_accessor :scope_to_association_method

    # Set to false to turn off admin notes
    attr_accessor :admin_notes


    def initialize(namespace, resource, options = {})
      @namespace = namespace
      @resource = resource
      @options = default_options.merge(options)
      @sort_order = @options[:sort_order]
      @page_configs = {}
      @menu_options = {}
      @member_actions, @collection_actions = [], []
      @scopes = []
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

    def resource_table_name
      resource.table_name
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
      namespace.module_name.try(:underscore)
    end

    # Returns a symbol for the route to use to get to the
    # collection of this resource
    def route_collection_path
      [route_prefix, controller.resources_configuration[:self][:route_collection_name], 'path'].compact.join('_').to_sym
    end

    # Returns the named route for an instance of this resource
    def route_instance_path
      [route_prefix, controller.resources_configuration[:self][:route_instance_name], 'path'].compact.join('_').to_sym
    end

    # Set the menu options. To not add this resource to the menu, just
    # call #menu(false)
    def menu(options = {})
      options = options == false ? { :display => false } : options
      @menu_options = options
    end

    # Returns the name to put this resource under in the menu
    def parent_menu_item_name
      @menu_options[:parent]
    end

    # Returns the name to be displayed in the menu for this resource
    def menu_item_name
      @menu_options[:label] || plural_resource_name
    end

    # Should this resource be added to the menu system?
    def include_in_menu?
      return false if @menu_options[:display] == false
      !(belongs_to? && !belongs_to_config.optional?)
    end


    # Clears all the member actions this resource knows about
    def clear_member_actions!
      @member_actions = []
    end

    def clear_collection_actions!
      @collection_actions = []
    end

    # Return an array of scopes for this resource
    def scopes
      @scopes
    end

    # Returns a scope for this object by its identifier
    def get_scope_by_id(id)
      id = id.to_s
      @scopes.find{|s| s.id == id }
    end

    def default_scope
      @default_scope
    end

    # Create a new scope object for this resource
    def scope(*args, &block)
      options = args.extract_options!
      @scopes << ActiveAdmin::Scope.new(*args, &block)
      if options[:default]
        @default_scope = @scopes.last
      end
    end

    # Are admin notes turned on for this resource
    def admin_notes?
      admin_notes.nil? ? ActiveAdmin.admin_notes : admin_notes
    end

    def belongs_to(target, options = {})
      @belongs_to = Resource::BelongsTo.new(self, target, options)
      controller.belongs_to(target, options.dup)
    end

    def belongs_to_config
      @belongs_to
    end

    # Do we belong to another resource
    def belongs_to?
      !belongs_to_config.nil?
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
