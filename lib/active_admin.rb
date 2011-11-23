require 'meta_search'
require 'bourbon'
require 'devise'
require 'kaminari'
require 'formtastic'
require 'sass'
require 'active_admin/arbre'
require 'active_admin/engine'

module ActiveAdmin

  autoload :VERSION,                  'active_admin/version'
  autoload :Application,              'active_admin/application'
  autoload :AssetRegistration,        'active_admin/asset_registration'
  autoload :Breadcrumbs,              'active_admin/breadcrumbs'
  autoload :Callbacks,                'active_admin/callbacks'
  autoload :Component,                'active_admin/component'
  autoload :ControllerAction,         'active_admin/controller_action'
  autoload :CSVBuilder,               'active_admin/csv_builder'
  autoload :Dashboards,               'active_admin/dashboards'
  autoload :DependencyChecker,        'active_admin/dependency_checker'
  autoload :Deprecation,              'active_admin/deprecation'
  autoload :Devise,                   'active_admin/devise'
  autoload :DSL,                      'active_admin/dsl'
  autoload :Event,                    'active_admin/event'
  autoload :FormBuilder,              'active_admin/form_builder'
  autoload :FilterFormBuilder,        'active_admin/filter_form_builder'
  autoload :Inputs,                   'active_admin/inputs'
  autoload :Iconic,                   'active_admin/iconic'
  autoload :Menu,                     'active_admin/menu'
  autoload :MenuItem,                 'active_admin/menu_item'
  autoload :Namespace,                'active_admin/namespace'
  autoload :PageConfig,               'active_admin/page_config'
  autoload :Reloader,                 'active_admin/reloader'
  autoload :Resource,                 'active_admin/resource'
  autoload :ResourceController,       'active_admin/resource_controller'
  autoload :Renderer,                 'active_admin/renderer'
  autoload :Scope,                    'active_admin/scope'
  autoload :ScopeChain,               'active_admin/helpers/scope_chain'
  autoload :SidebarSection,           'active_admin/sidebar_section'
  autoload :TableBuilder,             'active_admin/table_builder'
  autoload :ViewFactory,              'active_admin/view_factory'
  autoload :ViewHelpers,              'active_admin/view_helpers'
  autoload :Views,                    'active_admin/views'

  class Railtie < ::Rails::Railtie
    # Add load paths straight to I18n, so engines and application can overwrite it.
    require 'active_support/i18n'
    I18n.load_path += Dir[File.expand_path('../active_admin/locales/*.yml', __FILE__)]
  end

  # The instance of the configured application
  @@application = ::ActiveAdmin::Application.new
  mattr_accessor :application

  class << self

    # Gets called within the initializer
    def setup
      yield(application)
      application.prepare!
    end

    delegate :register, :to => :application
    delegate :unload!,  :to => :application
    delegate :load!,    :to => :application
    delegate :routes,   :to => :application

    # Returns true if this rails application has the asset
    # pipeline enabled.
    def use_asset_pipeline?
      DependencyChecker.rails_3_1? && Rails.application.config.assets.enabled
    end

    # Migration MoveAdminNotesToComments generated with version 0.2.2 might reference
    # to ActiveAdmin.default_namespace.
    delegate :default_namespace, :to => :application
    ActiveAdmin::Deprecation.deprecate self, :default_namespace, 
      "ActiveAdmin.default_namespace is deprecated. Please use ActiveAdmin.application.default_namespace"

  end
end

ActiveAdmin::DependencyChecker.check!

require 'active_admin/comments'
