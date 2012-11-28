require 'meta_search'
require 'bourbon'
require 'devise'
require 'kaminari'
require 'formtastic'
require 'sass'
require 'inherited_resources'
require 'jquery-rails'
require 'arbre'
require 'active_admin/dependency_checker' 
require 'active_admin/sass/helpers'
require 'active_admin/engine'

module ActiveAdmin

  autoload :VERSION,                  'active_admin/version'
  autoload :Application,              'active_admin/application'
  autoload :AssetRegistration,        'active_admin/asset_registration'
  autoload :Breadcrumbs,              'active_admin/breadcrumbs'
  autoload :Callbacks,                'active_admin/callbacks'
  autoload :Component,                'active_admin/component'
  autoload :BaseController,           'active_admin/base_controller'
  autoload :ControllerAction,         'active_admin/controller_action'
  autoload :CSVBuilder,               'active_admin/csv_builder'
  autoload :Dashboards,               'active_admin/dashboards'
  autoload :Deprecation,              'active_admin/deprecation'
  autoload :Devise,                   'active_admin/devise'
  autoload :DSL,                      'active_admin/dsl'
  autoload :Event,                    'active_admin/event'
  autoload :FormBuilder,              'active_admin/form_builder'
  autoload :Inputs,                   'active_admin/inputs'
  autoload :Iconic,                   'active_admin/iconic'
  autoload :Menu,                     'active_admin/menu'
  autoload :MenuItem,                 'active_admin/menu_item'
  autoload :Namespace,                'active_admin/namespace'
  autoload :Page,                     'active_admin/page'
  autoload :PagePresenter,            'active_admin/page_presenter'
  autoload :PageController,           'active_admin/page_controller'
  autoload :PageDSL,                  'active_admin/page_dsl'
  autoload :Reloader,                 'active_admin/reloader'
  autoload :Resource,                 'active_admin/resource'
  autoload :ResourceController,       'active_admin/resource_controller'
  autoload :ResourceDSL,              'active_admin/resource_dsl'
  autoload :Scope,                    'active_admin/scope'
  autoload :ScopeChain,               'active_admin/helpers/scope_chain'
  autoload :SidebarSection,           'active_admin/sidebar_section'
  autoload :TableBuilder,             'active_admin/table_builder'
  autoload :ViewFactory,              'active_admin/view_factory'
  autoload :ViewHelpers,              'active_admin/view_helpers'
  autoload :Views,                    'active_admin/views'

  # @see https://github.com/svenfuchs/rails-i18n/blob/master/lib/rails_i18n/railtie.rb
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'active_admin-i18n' do |app|
      ActiveAdmin::Railtie.instance_eval do
        pattern = pattern_from app.config.i18n.available_locales

        add("active_admin/locales/#{pattern}.yml")
      end
    end

    protected

    def self.add(pattern)
      files = Dir[File.join(File.dirname(__FILE__), pattern)]
      I18n.load_path.concat(files)
    end

    def self.pattern_from(args)
      array = Array(args || [])
      array.blank? ? '*' : "{#{array.join ','}}"
    end
  end

  class << self

    attr_accessor :application

    def application
      @application ||= ::ActiveAdmin::Application.new
    end

    # Gets called within the initializer
    def setup
      application.setup!
      yield(application)
      application.prepare!
    end

    delegate :register,      :to => :application
    delegate :register_page, :to => :application
    delegate :unload!,       :to => :application
    delegate :load!,         :to => :application
    delegate :routes,        :to => :application

    # Returns true if this rails application has the asset
    # pipeline enabled.
    def use_asset_pipeline?
      DependencyChecker.rails_3_1? && Rails.application.config.try(:assets).try(:enabled)
    end

    # Migration MoveAdminNotesToComments generated with version 0.2.2 might reference
    # to ActiveAdmin.default_namespace.
    delegate :default_namespace, :to => :application
    ActiveAdmin::Deprecation.deprecate self, :default_namespace, 
      "ActiveAdmin.default_namespace is deprecated. Please use ActiveAdmin.application.default_namespace"

    # A callback is triggered each time (before) Active Admin loads the configuration files.
    # In development mode, this will happen whenever the user changes files. In production
    # it only happens on boot.
    #
    # The block takes the current instance of [ActiveAdmin::Application]
    #
    # Example:
    #
    #     ActiveAdmin.before_load do |app|
    #       # Do some stuff before AA loads
    #     end
    #
    # @param [Block] block A block to call each time (before) AA loads resources
    def before_load(&block)
      ActiveAdmin::Event.subscribe ActiveAdmin::Application::BeforeLoadEvent, &block
    end

    # A callback is triggered each time (after) Active Admin loads the configuration files. This
    # is an opportunity to hook into Resources after they've been loaded.
    #
    # The block takes the current instance of [ActiveAdmin::Application]
    #
    # Example:
    #
    #     ActiveAdmin.after_load do |app|
    #       app.namespaces.each do |name, namespace|
    #         puts "Namespace: #{name} loaded!"
    #       end
    #     end
    #
    # @param [Block] block A block to call each time (after) AA loads resources
    def after_load(&block)
      ActiveAdmin::Event.subscribe ActiveAdmin::Application::AfterLoadEvent, &block
    end

  end

end

ActiveAdmin::DependencyChecker.check!

# Require internal Plugins
require 'active_admin/comments'
require 'active_admin/batch_actions'
require 'active_admin/filters'
