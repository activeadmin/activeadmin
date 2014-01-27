require 'inherited_resources'

require 'active_admin/controllers/resource/action_builder'
require 'active_admin/controllers/resource/decorators'
require 'active_admin/controllers/resource/data_access'
require 'active_admin/controllers/resource/scoping'
require 'active_admin/controllers/resource/sidebars'
require 'active_admin/controllers/resource/resource_class_methods'

module ActiveAdmin
  # All Resources Controller inherits from this controller.
  # It implements actions and helpers for resources.
  class ResourceController < BaseController

    layout :determine_active_admin_layout

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    include Controllers::Resource::ActionBuilder
    include Controllers::Resource::Decorators
    include Controllers::Resource::DataAccess
    include Controllers::Resource::Scoping
    include Controllers::Resource::Sidebars
    extend  Controllers::Resource::ResourceClassMethods

    def self.active_admin_config=(config)
      if @active_admin_config = config
        defaults :resource_class => config.resource_class,
                 :route_prefix   => config.route_prefix,
                 :instance_name  => config.resource_name.singular
      end
    end

    # Inherited Resources uses the `self.inherited(base)` hook to add
    # in `self.resource_class`. To override it, we need to install
    # our resource_class method each time we're inherited from.
    def self.inherited(base)
      super(base)
      base.override_resource_class_methods!
    end

    private

    # Returns the renderer class to use for the given action.
    def renderer_for(action)
      active_admin_namespace.view_factory["#{action}_page"]
    end
    helper_method :renderer_for

  end
end
