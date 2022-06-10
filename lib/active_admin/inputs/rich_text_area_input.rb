# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    class RichTextAreaInput < ::Formtastic::Inputs::StringInput
      def to_html
        input_wrapping do
          editor_tag = builder.rich_text_area(method, input_html_options)
          editor = template.content_tag('div', editor_tag, class: 'trix-editor-wrapper')
          label_html + editor
        end
      end
    end
  end
end