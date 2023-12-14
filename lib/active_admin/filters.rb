# frozen_string_literal: true
require "active_admin/filters/dsl"
require "active_admin/filters/resource_extension"
require "active_admin/filters/formtastic_addons"
require "active_admin/filters/forms"
require "active_admin/helpers/optional_display"
require "active_admin/view_helpers/method_or_proc_helper" # method used in lib/active_admin/filters/forms.rb

# Add our Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
ActiveAdmin::Resource.send :include, ActiveAdmin::Filters::ResourceExtension
ActiveAdmin::ViewHelpers.send :include, ActiveAdmin::Filters::ViewHelper
