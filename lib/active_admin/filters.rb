# frozen_string_literal: true
require_relative "filters/dsl"
require_relative "filters/resource_extension"
require_relative "filters/formtastic_addons"
require_relative "filters/forms"
require_relative "helpers/optional_display"

# Add our Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
ActiveAdmin::Resource.send :include, ActiveAdmin::Filters::ResourceExtension
