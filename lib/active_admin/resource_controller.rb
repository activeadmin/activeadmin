require 'inherited_resources'
require 'active_admin/resource_controller/actions'
require 'active_admin/resource_controller/action_builder'
require 'active_admin/resource_controller/callbacks'
require 'active_admin/resource_controller/collection'
require 'active_admin/resource_controller/filters'
require 'active_admin/resource_controller/scoping'

module ActiveAdmin
  # All Resources Controller inherits from this controller.
  # It implements actions and helpers for resources.
  class ResourceController < BaseController
    layout :determine_active_admin_layout

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    ACTIVE_ADMIN_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]

    include Actions
    include ActionBuilder
    include Callbacks
    include Collection
    include Filters
    include Scoping

    class << self
      def active_admin_config=(config)
        @active_admin_config = config
        defaults  :resource_class => config.resource_class,
                  :route_prefix => config.route_prefix,
                  :instance_name => config.underscored_resource_name
      end

      public :belongs_to
    end

    private

    # Determine which layout to use.
    #
    #   1.  If we're rendering a standard Active Admin action, we want layout(false)
    #       because these actions are subclasses of the Base page (which implementes
    #       all the required layout code)
    #   2.  If we're rendering a custom action, we'll use the active_admin layout so
    #       that users can render any template inside Active Admin.
    def determine_active_admin_layout
      ACTIVE_ADMIN_ACTIONS.include?(params[:action].to_sym) ? false : 'active_admin'
    end

    # Returns the renderer class to use for the given action.
    def renderer_for(action)
      active_admin_namespace.view_factory["#{action}_page"]
    end
    helper_method :renderer_for

  end
end
