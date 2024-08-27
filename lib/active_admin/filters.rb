# frozen_string_literal: true
require "active_admin/filters/dsl"
require "active_admin/filters/resource_extension"
require "active_admin/filters/formtastic_addons"
require "active_admin/filters/forms"
require "active_admin/helpers/optional_display"

# Add our Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
ActiveAdmin::Resource.send :include, ActiveAdmin::Filters::ResourceExtension
