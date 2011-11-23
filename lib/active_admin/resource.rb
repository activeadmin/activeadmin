require 'active_admin/resource/action_items'
require 'active_admin/resource/naming'
require 'active_admin/resource/scopes'
require 'active_admin/resource/sidebars'

module ActiveAdmin

  # Resource is the primary data storage for resource configuration in Active Admin
  #
  # When you register a resource (ActiveAdmin.register Post) you are actually creating
  # a new Resource instance within the given Namespace.
  #
  # The instance of the current resource is available in ResourceController and views
  # by calling the #active_admin_config method.
  #
  class Resource < Config

    # Event dispatched when a new resource is registered
    RegisterEvent = 'active_admin.resource.register'.freeze

    autoload :BelongsTo, 'active_admin/resource/belongs_to'

    # An array of member actions defined for this resource
    attr_reader :member_actions

    # An array of collection actions defined for this resource
    attr_reader :collection_actions

    # The default sort order to use in the controller
    attr_accessor :sort_order

    # Scope this resource to an association in the controller
    attr_accessor :scope_to

    # If we're scoping resources, use this method on the parent to return the collection
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
        @member_actions, @collection_actions = [], []
      end
    end

    include Base
    include ActionItems
    include Naming
    include Scopes
    include Sidebars


    def resource_table_name
      resource.quoted_table_name
    end


    # Returns the named route for an instance of this resource
    def route_instance_path
      [route_prefix, controller.resources_configuration[:self][:route_instance_name], 'path'].compact.join('_').to_sym
    end

    # Returns a symbol for the route to use to get to the
    # collection of this resource
    def route_collection_path
      route = super

      # Handle plural resources.
      if controller.resources_configuration[:self][:route_collection_name] ==
            controller.resources_configuration[:self][:route_instance_name]
        route = route.to_s.gsub('_path', '_index_path').to_sym
      end

      route
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

    def include_in_menu?
      super && !(belongs_to? && !belongs_to_config.optional?)
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
  end # class Resource < Config
end # module ActiveAdmin
