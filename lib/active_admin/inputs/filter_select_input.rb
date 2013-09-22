module ActiveAdmin
  module Inputs
    class FilterSelectInput < ::Formtastic::Inputs::SelectInput
      include FilterBase

      # If MetaSearch already responds to the given method, just use it.
      #
      # Otherwise:
      # When it's a HABTM or has_many association, Formtastic builds "object_ids".
      # That doesn't fit our scenario, so we override it here.
      def input_name
        return method if @object.respond_to? method

        name = method.to_s
        name.concat '_id' if reflection
        name.concat multiple? ? '_in' : '_eq'
      end

      # Provide the AA translation to the blank input field.
      def include_blank
        I18n.t 'active_admin.any' if super
      end

      # was "#{object_name}[#{association_primary_key}]"
      def input_html_options_name
        "#{object_name}[#{input_name}]"
      end

      # Would normally return true for has_many and HABTM, which would subsequently
      # cause the select field to be multi-select instead of a dropdown.
      def multiple_by_association?
        false
      end

      # Provides an efficient default lookup query if the attribute is a DB column.
      def collection
        unless Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR < 2
          return pluck_column if !options[:collection] && column_for(method)
        end
        super
      end

      def pluck_column
        @object.base.reorder("#{method} asc").uniq.pluck method
      end

    end
  end
end
