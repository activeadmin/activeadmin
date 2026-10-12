# frozen_string_literal: true

module ActiveAdmin
  module Inputs
    class AssociationInput < ::Formtastic::Inputs::StringInput
      def to_html
        input_wrapping do
          label_html << builder.text_field(reflection.foreign_key, input_html_options)
        end
      end

      def input_html_options
        options = super
        options.merge(
          name: input_name,
          id: input_html_options_id(options)
        )
      end

      def input_html_options_id(options)
        options[:id] || "#{object_name}_#{reflection.foreign_key}"
      end

      def input_name
        if builder.options.key?(:index)
          "#{object_name}[#{builder.options[:index]}][#{reflection.foreign_key}]"
        else
          "#{object_name}[#{reflection.foreign_key}]"
        end
      end

      def reflection
        @reflection ||= object.class.reflect_on_association(method)
      end
    end
  end
end
