require 'meta_search'

module ActiveAdmin
  
  autoload :Renderer,         'active_admin/renderer'
  autoload :TableBuilder,     'active_admin/table_builder'
  autoload :FormBuilder,      'active_admin/form_builder'
  autoload :AdminController,  'active_admin/admin_controller'
  autoload :ViewHelpers,      'active_admin/view_helpers'
  autoload :Breadcrumbs,      'active_admin/breadcrumbs'
  autoload :Filters,          'active_admin/filters'
  autoload :Pages,            'active_admin/pages'
  autoload :Sidebar,          'active_admin/sidebar'
  autoload :ActionItems,      'active_admin/action_items'
  autoload :AssetRegistration,'active_admin/asset_registration'

  extend AssetRegistration

  # The default namespace to put controllers and routes in
  mattr_accessor :default_namespace
  @@default_namespace = :admin

  # A hash of configurations for each of the registered resources
  mattr_accessor :resources
  @@resources = {}

  class << self

    def init!
      register_stylesheet 'active_admin.css'
      register_javascript 'active_admin_vendor.js'
      register_javascript 'active_admin.js'
    end

    def register(resource, options = {}, &block)
      opts = resources[resource] = default_options.merge(options)
      opts[:namespace_module] = opts[:namespace].to_s.camelcase if opts[:namespace]
      opts[:controller_name] = [opts[:namespace_module], resource.name.pluralize + "Controller"].compact.join('::')
      
      if opts[:namespace] && !const_defined?(opts[:namespace_module])
        eval "module ::#{opts[:namespace_module]}; end"
      end

      eval "class ::#{opts[:controller_name]} < ActiveAdmin::AdminController; end"

      opts[:controller_name].constantize.class_eval(&block) if block_given?
    end

    def default_options
      { :namespace => default_namespace }
    end

  end
end

ActiveAdmin.init!
