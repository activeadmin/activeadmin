require 'meta_search'
require 'devise'
require 'will_paginate'
require 'sass'
require 'active_admin/arbre'

module ActiveAdmin

  autoload :VERSION,                  'active_admin/version'
  autoload :ActionItems,              'active_admin/action_items'
  autoload :AssetRegistration,        'active_admin/asset_registration'
  autoload :Breadcrumbs,              'active_admin/breadcrumbs'
  autoload :Callbacks,                'active_admin/callbacks'
  autoload :Component,                'active_admin/component'
  autoload :ControllerAction,         'active_admin/controller_action'
  autoload :Dashboards,               'active_admin/dashboards'
  autoload :Devise,                   'active_admin/devise'
  autoload :DSL,                      'active_admin/dsl'
  autoload :Event,                    'active_admin/event'
  autoload :FormBuilder,              'active_admin/form_builder'
  autoload :Iconic,                   'active_admin/iconic'
  autoload :Menu,                     'active_admin/menu'
  autoload :MenuItem,                 'active_admin/menu_item'
  autoload :Namespace,                'active_admin/namespace'
  autoload :PageConfig,               'active_admin/page_config'
  autoload :Resource,                 'active_admin/resource'
  autoload :ResourceController,       'active_admin/resource_controller'
  autoload :Renderer,                 'active_admin/renderer'
  autoload :Scope,                    'active_admin/scope'
  autoload :Sidebar,                  'active_admin/sidebar'
  autoload :TableBuilder,             'active_admin/table_builder'
  autoload :ViewFactory,              'active_admin/view_factory'
  autoload :ViewHelpers,              'active_admin/view_helpers'
  autoload :Views,                    'active_admin/views'

  module Configuration

    # The default namespace to put controllers and routes inside. Set this
    # in config/initializers/active_admin.rb using:
    # 
    #   config.default_namespace = :super_admin
    #
    @@default_namespace = :admin
    mattr_accessor :default_namespace

    # The default number of resources to display on index pages
    @@default_per_page = 30
    mattr_accessor :default_per_page

    # The default sort order for index pages
    @@default_sort_order = 'id_desc'
    mattr_accessor :default_sort_order

    # A hash of all the registered namespaces
    @@namespaces = {}
    mattr_accessor :namespaces

    # The title which gets displayed in the main layout
    @@site_title = ""
    mattr_accessor :site_title

    # Load paths for admin configurations. Add folders to this load path
    # to load up other resources for administration. External gems can
    # include their paths in this load path to provide active_admin UIs
    @@load_paths = [File.expand_path('app/admin', Rails.root)]
    mattr_accessor :load_paths

    # The view factory to use to generate all the view classes. Take
    # a look at ActiveAdmin::ViewFactory
    @@view_factory = ActiveAdmin::ViewFactory.new
    mattr_accessor :view_factory

    # DEPRECATED: This option is deprecated and will be removed. Use
    # the #allow_comments_in option instead
    mattr_accessor :admin_notes

    # The method to call in controllers to get the current user
    @@current_user_method = :current_admin_user
    mattr_accessor :current_user_method

    # The method to call in the controllers to ensure that there
    # is a currently authenticated admin user
    @@authentication_method = :authenticate_admin_user!
    mattr_accessor :authentication_method

    # Active Admin makes educated guesses when displaying objects, this is
    # the list of methods it tries calling in order
    @@display_name_methods = [:display_name, :full_name, :name, :username, :login, :title, :email, :to_s]
    mattr_accessor :display_name_methods

  end

  extend Configuration
  extend AssetRegistration

  class << self


    # Gets called within the initializer
    def setup
      # Register the default assets
      register_stylesheet 'admin/active_admin.css'
      register_javascript 'active_admin_vendor.js'
      register_javascript 'active_admin.js'

      # Since we're dealing with all our own file loading, we need
      # to remove our paths from the ActiveSupport autoload paths.
      # If not, file naming becomes very important and can cause clashes.
      ActiveSupport::Dependencies.autoload_paths.reject!{|path| load_paths.include?(path) }

      # Add the Active Admin view path to the rails view path
      ActionController::Base.append_view_path File.expand_path('../active_admin/views/templates', __FILE__)

      # Don't eagerload our configs, we'll deal with them ourselves
      Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.reject do |path| 
        load_paths.include?(path)
      end

      # Dispatch request which gets triggered once in production
      # and on every require in development mode
      ActionDispatch::Callbacks.to_prepare :active_admin do
        ActiveAdmin.unload!
        Rails.application.reload_routes!
      end

      yield self

      generate_stylesheets
    end

    def generate_stylesheets
      # Setup SASS
      require 'sass/plugin' # This must be required after initialization
      Sass::Plugin.add_template_location(File.expand_path("../active_admin/stylesheets/", __FILE__), File.join(Sass::Plugin.options[:css_location], 'admin'))
    end

    # Registers a brand new configuration for the given resource.
    def register(resource, options = {}, &block)
      namespace_name = options[:namespace] == false ? :root : (options[:namespace] || default_namespace || :root)
      namespace = find_or_create_namespace(namespace_name)
      namespace.register(resource, options, &block)
    end

    # Creates a namespace for the given name
    def find_or_create_namespace(name)
      return namespaces[name] if namespaces[name]
      namespace = Namespace.new(name)
      ActiveAdmin::Event.dispatch ActiveAdmin::Namespace::RegisterEvent, namespace
      namespaces[name] = namespace
      namespace
    end


    # Stores if everything has been loaded or we need to reload
    @@loaded = false

    # Returns true if all the configuration files have been loaded.
    def loaded?
      @@loaded
    end

    # Removes all the controllers that were defined by registering
    # resources for administration.
    #
    # We remove them, then load them on each request in development
    # to allow for changes without having to restart the server.
    def unload!
      namespaces.values.each{|namespace| namespace.unload! }
      self.namespaces = {}
      @@loaded = false
    end

    # Loads all of the ruby files that are within the load path of
    # ActiveAdmin.load_paths. This should load all of the administration
    # UIs so that they are available for the router to proceed.
    #
    # The files are only loaded if we haven't already loaded all the files
    # and they aren't marked for re-loading. To mark the files for re-loading
    # you must first call ActiveAdmin.unload!
    def load!
      # No work to do if we've already loaded
      return false if loaded?

      # Load files
      files_in_load_path.each{|file| load file }

      # If no configurations, let's make sure you can still login
      load_default_namespace if namespaces.values.empty?

      # Load Menus
      namespaces.values.each{|namespace| namespace.load_menu! }

      @@loaded = true
    end

    # Returns ALL the files to load from all the load paths
    def files_in_load_path
      load_paths.flatten.compact.uniq.collect{|path| Dir["#{path}/**/*.rb"] }.flatten
    end

    # Creates all the necessary routes for the ActiveAdmin configurations
    #
    # Use this within the routes.rb file:
    #
    #   Application.routes.draw do |map|
    #     ActiveAdmin.routes(self)
    #   end
    #
    def routes(router)
      # Ensure that all the configurations (which define the routes)
      # are all loaded
      load!

      # Define any necessary dashboard routes
      router.instance_exec(namespaces.values) do |namespaces|
        namespaces.each do |namespace|
          if namespace.root?
            match '/' => 'dashboard#index', :as => 'dashboard'
          else
            name = namespace.name
            match name.to_s => "#{name}/dashboard#index", :as => "#{name.to_s}_dashboard"
          end
        end
      end

      # Now define the routes for each resource
      router.instance_exec(namespaces) do |namespaces|
        resources = namespaces.values.collect{|n| n.resources.values }.flatten
        resources.each do |config|

          # Define the block the will get eval'd within the namespace
          route_definition_block = Proc.new do
            resources config.underscored_resource_name.pluralize do

              # Define any member actions
              member do
                config.member_actions.each do |action|
                  # eg: get :comment
                  send(action.http_verb, action.name)
                end
              end

              # Define any collection actions
              collection do
                config.collection_actions.each do |action|
                  send(action.http_verb, action.name)
                end
              end
            end
          end

          # Add in the parent if it exists
          if config.belongs_to?
            routes_for_belongs_to = route_definition_block.dup
            route_definition_block = Proc.new do
              # If its optional, make the normal resource routes
              instance_eval &routes_for_belongs_to if config.belongs_to_config.optional?

              # Make the nested belongs_to routes
              resources config.belongs_to_config.target.underscored_resource_name.pluralize do
                instance_eval &routes_for_belongs_to
              end
            end
          end

          # Add on the namespace if required
          if !config.namespace.root?
            routes_in_namespace = route_definition_block.dup
            route_definition_block = Proc.new do
              namespace config.namespace.name do
                instance_eval(&routes_in_namespace)
              end
            end
          end

          instance_eval &route_definition_block
        end
      end
    end

    def load_default_namespace
      find_or_create_namespace(default_namespace)
    end

    #
    # Add before, around and after filters to each registered resource.
    #
    # eg:
    #
    #   ActiveAdmin.before_filter :authenticate_admin!
    #
    def before_filter(*args, &block)
      ResourceController.before_filter(*args, &block)
    end

    def after_filter(*args, &block)
      ResourceController.after_filter(*args, &block)
    end

    def around_filter(*args, &block)
      ResourceController.around_filter(*args, &block)
    end

    # Helper method to add a dashboard section
    def dashboard_section(name, options = {}, &block)
      ActiveAdmin::Dashboards.add_section(name, options, &block)
    end

  end
end

require 'active_admin/comments'
