require 'active_admin/filters/dsl'
require "active_admin/filters/resource_extension"
require 'active_admin/filters/forms'

# Add our Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
ActiveAdmin::Resource.send    :include, ActiveAdmin::Filters::ResourceExtension
ActiveAdmin::ViewHelpers.send :include, ActiveAdmin::Filters::ViewHelper
