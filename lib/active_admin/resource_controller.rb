require 'inherited_resources'
require 'active_admin/resource_controller/actions'
require 'active_admin/resource_controller/action_builder'
require 'active_admin/resource_controller/data_access'
require 'active_admin/resource_controller/decorators'
require 'active_admin/resource_controller/scoping'
require 'active_admin/resource_controller/sidebars'
require 'active_admin/resource_controller/resource_class_methods'

module ActiveAdmin
  # All Resources Controller inherits from this controller.
  # It implements actions and helpers for resources.
  class ResourceController < BaseController
    layout :determine_active_admin_layout

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    include Actions
    include ActionBuilder
    include Decorators
    include DataAccess
    include Scoping
    include Sidebars
    extend  ResourceClassMethods

    class << self
      def active_admin_config=(config)
        @active_admin_config = config

        unless config.nil?
          defaults :resource_class => config.resource_class, :route_prefix => config.route_prefix, :instance_name => config.resource_name.singular
        end
      end

      # Inherited Resources uses the inherited(base) hook method to
      # add in the Base.resource_class class method. To override it, we
      # need to install our resource_class method each time we're inherited from.
      def inherited(base)
        super(base)
        base.override_resource_class_methods!
      end

      public :belongs_to
    end

    private

    # Returns the renderer class to use for the given action.
    def renderer_for(action)
      active_admin_namespace.view_factory["#{action}_page"]
    end
    helper_method :renderer_for

  end
end
