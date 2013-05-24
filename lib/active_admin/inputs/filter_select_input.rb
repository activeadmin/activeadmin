module ActiveAdmin
  module Inputs
    class FilterSelectInput < ::Formtastic::Inputs::SelectInput
      include FilterBase

      # When it's a HABTM or has_many association, Formtastic builds "object_ids".
      # Metasearch requires "objects_id", hence the convoluted override.
      #
      # We use "_in" instead of "_eq" since it works for single or multiple values.
      def input_name
        reflection ? "#{method}_id_in" : "#{method}_in"
      end

      # Include the "Any" option if it's a dropdown, but not if it's a multi-select.
      def input_options
        super.merge :include_blank => multiple? ? false : I18n.t('active_admin.any')
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
          return @object.base.uniq.pluck method if !options[:collection] && column_for(method)
        end
        super
      end

    end
  end
end
