ActiveAdmin.before_load do |app|

  require 'active_admin/filters/dsl'
  require "active_admin/filters/resource_extension"

  # Add our Extensions
  ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
  ActiveAdmin::Resource.send :include, ActiveAdmin::Filters::ResourceExtension

end
