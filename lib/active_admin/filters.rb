require 'active_admin/filters/dsl'
require 'active_admin/filters/resource_extension'
require 'active_admin/filters/formtastic_addons'
require 'active_admin/filters/forms'
require 'active_admin/helpers/optional_display'
require 'active_admin/filters/active_sidebar'

# Add our Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
ActiveAdmin::Resource.send    :include, ActiveAdmin::Filters::ResourceExtension
ActiveAdmin::ViewHelpers.send :include, ActiveAdmin::Filters::ViewHelper
