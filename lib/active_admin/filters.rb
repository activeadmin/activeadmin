# frozen_string_literal: true
require_relative "filters/dsl"
require_relative "filters/resource_extension"
require_relative "filters/formtastic_addons"
require_relative "filters/forms"
require_relative "helpers/optional_display"

module ActiveAdmin
  module Filters
    # Ransack locales do not translate the case-insensitive `i_*` predicates,
    # so fall back to the translation of their case-sensitive counterpart.
    def self.predicate_label(predicate)
      predicate = predicate.to_s
      I18n.t(:"ransack.predicates.#{predicate}", default: [:"ransack.predicates.#{predicate.delete_prefix("i_")}", predicate])
    end
  end
end

# Add our Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Filters::DSL
ActiveAdmin::Resource.send :include, ActiveAdmin::Filters::ResourceExtension
