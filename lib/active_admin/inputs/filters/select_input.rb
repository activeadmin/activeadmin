# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class SelectInput < ::Formtastic::Inputs::SelectInput
        include Base

        def input_name
          return method if seems_searchable?

          searchable_method_name + (multiple? ? "_in" : "_eq")
        end

        def searchable_method_name
          if searchable_has_many_through?
            "#{reflection.through_reflection.name}_#{reflection.foreign_key}"
          else
            name = method.to_s
            name.concat "_#{reflection.association_primary_key}" if reflection_searchable?
            name
          end
        end

        # Provide the AA translation to the blank input field.
        def include_blank
          I18n.t "active_admin.any" if super
        end

        def input_html_options_name
          "#{object_name}[#{input_name}]" # was "#{object_name}[#{association_primary_key}]"
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
          method_name = method_name_for(method)

          klass.reorder("#{method_name} asc").distinct.pluck method_name
        end

        def reflection_searchable?
          reflection && !reflection.polymorphic?
        end

      end
    end
  end
end
