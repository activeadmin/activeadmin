# This is a common set of Formtastic overrides needed to build a filter form
# that lets you select from a set of search methods for a given attribute.
#
# Your class must declare available filters for this module to work.
# Those filters must be recognizable by Metasearch. For example:
#
#   class FilterNumericInput < ::Formtastic::Inputs::NumberInput
#     include FilterBase
#     include FilterBase::SearchMethodSelect
#
#     filter :equals, :greater_than, :less_than
#   end
#
module ActiveAdmin
  module Inputs
    module FilterBase
      module SearchMethodSelect

        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          attr_reader :filters

          def filter(*filters)
            (@filters ||= []).push *filters
          end
        end

        def wrapper_html_options
          opts = super
          (opts[:class] ||= '') << ' select_and_search'
          opts
        end

        def to_html
          input_wrapping do
            label_html  << # your label
            select_html << # the dropdown that holds the available search methods
            input_html     # your input field
          end
        end

        def input_html
          builder.text_field current_filter, input_html_options
        end

        def select_html
          template.select_tag '', template.options_for_select(filter_options, current_filter)
        end

        def filters
          options[:filters] || self.class.filters
        end

        def current_filter
          @current_filter ||= begin
            methods = filters.map{ |f| "#{method}_#{f}" }
            methods.detect{ |m| @object.send m } || methods.first
          end
        end

        def filter_options
          filters.collect do |filter|
            [I18n.t("active_admin.filters.predicates.#{filter}"), "#{method}_#{filter}"]
          end
        end

      end
    end
  end
end
