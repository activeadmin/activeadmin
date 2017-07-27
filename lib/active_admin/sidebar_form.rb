require 'active_admin/sidebar_form/resource_extension'
require 'active_admin/sidebar_form/dsl'
require 'active_admin/sidebar_form/form'

ActiveAdmin::Resource.send :include, ActiveAdmin::SidebarForm::ResourceExtension
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::SidebarForm::DSL
ActiveAdmin::Views::SidebarSection.send :include, ActiveAdmin::SidebarForm::Form
