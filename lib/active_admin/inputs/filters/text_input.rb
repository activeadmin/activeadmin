module ActiveAdmin
  module Inputs
    module Filters
      class TextInput < ::Formtastic::Inputs::TextInput
        include Base
        include Base::SearchMethodSelect

        def input_html_options
          {
            cols: builder.default_text_area_width,
            rows: builder.default_text_area_height
          }.merge(super)
        end

        def to_html
          input_wrapping do
            label_html <<
            builder.text_area(method, input_html_options)
          end
        end

      end
    end
  end
end
