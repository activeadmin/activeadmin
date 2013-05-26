# This is a common set of Formtastic overrides needed to build a filter form
# that lets you select from a set of search methods for a given attribute.
#
# For example, FilterNumericInput uses this to let users choose from ==, >, and <.
#
# The `default_filters` method must be defined in your input class for this module to work.
# This method must return a nested array, with each child array's first element being a
# translation and the second being a search method that Metasearch recognizes.
# For example:
#
#   class FilterNumericInput < ::Formtastic::Inputs::NumberInput
#     include FilterBase
#     include FilterBase::SearchMethodSelect
#
#     def default_filters
#       [ [I18n.t('active_admin.equal_to'),     'eq'],
#         [I18n.t('active_admin.greater_than'), 'gt'],
#         [I18n.t('active_admin.less_than'),    'lt'] ]
#     end
#   end
#
module ActiveAdmin
  module Inputs
    module FilterBase
      module SearchMethodSelect

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
          template.select_tag '', select_options
        end

        def select_options
          template.options_for_select filters, current_filter
        end

        # Returns the filter currently in use, or the first one available
        def current_filter
          ( filters.detect{ |(_,query)| @object.send query } || filters.first )[1]
        end

        # TODO: document what can be done with `options[:filters]`
        def filters
          (options[:filters] || default_filters).collect do |(translation,scope)|
            [translation, "#{method}_#{scope}"]
          end
        end

      end
    end
  end
end
