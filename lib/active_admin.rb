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

  class << self

    def init!
      register_stylesheet 'active_admin.css'
      register_javascript 'active_admin_vendor.js'
      register_javascript 'active_admin.js'
    end

  end
end

ActiveAdmin.init!
