module ActiveAdmin
  module Inputs
    module Filters
      class BooleanInput < ::Formtastic::Inputs::SelectInput
        include Base

        def input_name
          return method if seems_searchable?

          "#{method}_eq"
        end

        def input_html_options_name
          "#{object_name}[#{input_name}]" # was "#{object_name}[#{association_primary_key}]"
        end

        # Provide the AA translation to the blank input field.
        def include_blank
          I18n.t 'active_admin.any' if super
        end
      end
    end
  end
end
