module ActiveAdmin
  module Inputs
    class FilterSelectInput < ::Formtastic::Inputs::SelectInput
      include FilterBase

      # If Ransack will likely respond to the given method, use it.
      #
      # Otherwise:
      # When it's a HABTM or has_many association, Formtastic builds "object_ids".
      # That doesn't fit our scenario, so we override it here.
      def input_name
        return method if seems_searchable?

        searchable_method_name.concat multiple? ? '_in' : '_eq'
      end

      def searchable_method_name
        # Deal with has_many :through relationships in filters
        # If the relationship is a HMT, we set the search logic to be something
        # like :#{through_association}_#{end_association_id}.
        if searchable_through_association?
          name = [reflection.through_reflection.name, reflection.foreign_key].join('_')
        else
          name = method.to_s
          name.concat '_id' if reflection
        end
        name
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
        if !options[:collection] && column
          pluck_column
        else
          super
        end
      end

      def pluck_column
        klass.reorder("#{method} asc").uniq.pluck method
      end

    end
  end
end
