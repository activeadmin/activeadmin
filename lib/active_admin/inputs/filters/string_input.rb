# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class StringInput < ::Formtastic::Inputs::StringInput
        include Base
        include Base::SearchMethodSelect

        filter :cont, :eq, :start, :end

        # If the filter method includes a search condition, build a normal string search field.
        # Else, build a search field with a companion dropdown to choose a search condition from.
        def to_html
          if seems_searchable?
            input_wrapping do
              label_html <<
              builder.text_field(method, input_html_options)
            end
          else
            super # SearchMethodSelect#to_html
          end
        end

      end
    end
  end
end
