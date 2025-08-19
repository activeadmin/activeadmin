# frozen_string_literal: true
module ActiveAdmin
  module Filters
    # This form builder defines methods to build filter forms such
    # as the one found in the sidebar of the index page of a standard resource.
    class FormBuilder < ::ActiveAdmin::FormBuilder
      include ::ActiveAdmin::Filters::FormtasticAddons
      self.input_namespaces = [::Object, ::ActiveAdmin::Inputs::Filters, ::ActiveAdmin::Inputs, ::Formtastic::Inputs]

      def filter(method, options = {})
        if method.present? && options[:as] ||= default_input_type(method)
          template.concat input(method, options)
        end
      end

      protected

      # Returns the default filter type for a given attribute. If you want
      # to use a custom search method, you have to specify the type yourself.
      def default_input_type(method, options = {})
        if /_(eq|cont|start|end)\z/.match?(method)
          :string
        elsif klass._ransackers.key?(method.to_s)
          klass._ransackers[method.to_s].type
        elsif reflection_for(method) || polymorphic_foreign_type?(method)
          :select
        elsif column = column_for(method)
          case column.type
          when :date, :datetime
            :date_range
          when :string, :text, :citext
            :string
          when :integer, :float, :decimal
            :numeric
          when :boolean
            :boolean
          end
        end
      end
    end
  end
end
