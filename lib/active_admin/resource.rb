require 'active_admin/resource/action_items'
require 'active_admin/resource/controllers'
require 'active_admin/resource/menu'
require 'active_admin/resource/page_presenters'
require 'active_admin/resource/pagination'
require 'active_admin/resource/routes'
require 'active_admin/resource/naming'
require 'active_admin/resource/scopes'
require 'active_admin/resource/includes'
require 'active_admin/resource/scope_to'
require 'active_admin/resource/sidebars'
require 'active_admin/resource/belongs_to'

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

    # The namespace this config belongs to
    attr_reader :namespace

    # The name of the resource class
    attr_reader :resource_class_name

    # An array of member actions defined for this resource
    attr_reader :member_actions

    # An array of collection actions defined for this resource
    attr_reader :collection_actions

    # The default sort order to use in the controller
    attr_writer :sort_order
    def sort_order
      @sort_order ||= (resource_class.respond_to?(:primary_key) ? resource_class.primary_key.to_s : 'id') + '_desc'
    end

    # Set the configuration for the CSV
    attr_writer :csv_builder

    # Set breadcrumb builder
    attr_writer :breadcrumb

    # Store a reference to the DSL so that we can dereference it during garbage collection.
    attr_accessor :dsl

    # The string identifying a class to decorate our resource with for the view.
    # nil to not decorate.
    attr_accessor :decorator_class_name

    module Base
      def initialize(namespace, resource_class, options = {})
        @namespace = namespace
        @resource_class_name = "::#{resource_class.name}"
        @options    = options
        @sort_order = options[:sort_order]
        @member_actions, @collection_actions = [], []
      end
    end

    include MethodOrProcHelper

    include Base
    include ActionItems
    include Authorization
    include Controllers
    include Menu
    include Naming
    include PagePresenters
    include Pagination
    include Scopes
    include Includes
    include ScopeTo
    include Sidebars
    include Routes

    # The class this resource wraps. If you register the Post model, Resource#resource_class
    # will point to the Post class
    def resource_class
      ActiveSupport::Dependencies.constantize(resource_class_name)
    end

    def decorator_class
      ActiveSupport::Dependencies.constantize(decorator_class_name) if decorator_class_name
    end

    def resource_table_name
      resource_class.quoted_table_name
    end

    def resource_column_names
      resource_class.column_names
    end

    def resource_quoted_column_name(column)
      resource_class.connection.quote_column_name(column)
    end

    # Clears all the member actions this resource knows about
    def clear_member_actions!
      @member_actions = []
    end

    def clear_collection_actions!
      @collection_actions = []
    end

    # Return only defined resource actions
    def defined_actions
      controller.instance_methods.map(&:to_sym) & ResourceController::ACTIVE_ADMIN_ACTIONS
    end

    def belongs_to(target, options = {})
      @belongs_to = Resource::BelongsTo.new(self, target, options)
      self.navigation_menu_name = target unless @belongs_to.optional?
      controller.send :belongs_to, target, options.dup
    end

    def belongs_to_config
      @belongs_to
    end

    # Do we belong to another resource?
    def belongs_to?
      !!belongs_to_config
    end

    # The csv builder for this resource
    def csv_builder
      @csv_builder || default_csv_builder
    end

    def breadcrumb
      instance_variable_defined?(:@breadcrumb) ? @breadcrumb : namespace.breadcrumb
    end

    def find_resource(id)
      resource = resource_class.public_send *method_for_find(id)
      decorator_class ? decorator_class.new(resource) : resource
    end

    private

    def method_for_find(id)
      if finder = resources_configuration[:self][:finder]
        [finder, id]
      elsif Rails::VERSION::MAJOR >= 4
        [:find_by, { resource_class.primary_key => id }]
      else
        [:"find_by_#{resource_class.primary_key}", id]
      end
    end

    def default_csv_builder
      @default_csv_builder ||= CSVBuilder.default_for_resource(resource_class)
    end

  end # class Resource
end # module ActiveAdmin
