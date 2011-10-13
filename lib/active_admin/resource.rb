require 'active_admin/resource/action_items'
require 'active_admin/resource/menu'
require 'active_admin/resource/naming'
require 'active_admin/resource/scopes'
require 'active_admin/resource/sidebars'

module ActiveAdmin

  # Resource is the primary data storage for resource configuration in Active
  # Admin
  #
  # When you register a resource (ActiveAdmin.register Post) you are actually
  # creating a new Resource instance within the given Namespace.
  #
  # The instance of the current resource is available in ResourceController and
  # views by calling the #active_admin_config method.
  #
  class Resource

    # Event dispatched when a new resource is registered
    RegisterEvent = 'active_admin.resource.register'.freeze

    autoload :BelongsTo, 'active_admin/resource/belongs_to'

    # The namespace this resource belongs to
    attr_reader :namespace

    # The class this resource wraps. If you register the Post model,
    # Resource#resource will point to the Post class
    attr_reader :resource

    # A hash of page configurations for the controller indexed by action name
    attr_reader :page_configs

    # An array of member actions defined for this resource
    attr_reader :member_actions

    # An array of collection actions defined for this resource
    attr_reader :collection_actions

    # The default sort order to use in the controller
    attr_accessor :sort_order

    # Scope this resource to an association in the controller
    attr_accessor :scope_to

    # If we're scoping resources, use this method on the parent to return the
    # collection
    attr_accessor :scope_to_association_method

    # Set to false to turn off admin notes
    attr_accessor :admin_notes

    # Set the configuration for the CSV
    attr_writer :csv_builder

    module Base
      def initialize(namespace, resource, options = {})
        @namespace = namespace
        @resource = resource
        @options = default_options.merge(options)
        @sort_order = @options[:sort_order]
        @page_configs = {}
        @member_actions, @collection_actions = [], []
      end
    end

    include Base
    include ActionItems
    include Menu
    include Naming
    include Scopes
    include Sidebars

    # determine both what resources belong_to a given resource,
    # and what resources it belongs_to

    def self.belongs_to_resources(controller_name, options = {})

      resource_list = []

      # max_depth limits how many resources away from the current one
      # we're willing to look. restricting this to 1 will return only
      # resources that belong_to the resource in question. 2 would return
      # resources that belong_to it and resources it belongs_to. et cetera.

      max_depth = options[:max_depth] ||= nil
      current_depth = 0

      # loop through the resources. we do this to grab not only the
      # relationships for the current resource, but to roll back through
      # its parents as well, if it also belongs_to another resource

      current_resource = controller_name
      next_resource = nil

      # collect all resources
      resources = ActiveAdmin.application.namespaces.values.collect {
                  |n| n.resources.values }.flatten

      while current_resource != nil and (max_depth == nil or depth < max_depth)

        resources.each do |resource|
          if resource.belongs_to? # if not, we don't care
            target = resource.belongs_to_config.target

            if resource.plural_underscored_resource_name == current_resource
              # oh, it's us? we have a parent then
              next_resource = target.plural_underscored_resource_name

            elsif target.plural_underscored_resource_name == current_resource
              # it's one of our children
              resource_list.push(resource)

            end
          end
        end

        current_resource = next_resource ||= nil
        next_resource = nil
        current_depth += 1 # let's not go too far

      end

      resource_list

    end

    def resource_table_name
      resource.quoted_table_name
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
      route = [route_prefix, controller.resources_configuration[:self][:route_collection_name]]

      if controller.resources_configuration[:self][:route_collection_name] ==
          controller.resources_configuration[:self][:route_instance_name]
        route << "index"
      end

      route << 'path'
      route.compact.join('_').to_sym
    end

    # Returns the named route for an instance of this resource
    def route_instance_path
      [route_prefix, controller.resources_configuration[:self][:route_instance_name], 'path'].compact.join('_').to_sym
    end

    # Clears all the member actions this resource knows about
    def clear_member_actions!
      @member_actions = []
    end

    def clear_collection_actions!
      @collection_actions = []
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

    # The csv builder for this resource
    def csv_builder
      @csv_builder || default_csv_builder
    end

    private

    def default_options
      {
        :namespace  => ActiveAdmin.application.default_namespace,
        :sort_order => "#{resource.respond_to?(:primary_key) ? resource.primary_key : 'id'}_desc"
      }
    end

    def default_csv_builder
      @default_csv_builder ||= CSVBuilder.default_for_resource(resource)
    end
  end # class Resource
end # module ActiveAdmin
