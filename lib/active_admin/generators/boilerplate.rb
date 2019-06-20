module ActiveAdmin
  module Generators
    class Boilerplate
      def initialize(class_name)
        @class_name = class_name
      end

      def attributes
        @class_name.constantize.new.attributes.keys
      end

      def assignable_attributes
        attributes - %w(id created_at updated_at)
      end

      def permit_params
        assignable_attributes.map { |a| a.to_sym.inspect }.join(', ')
      end

      def rows
        attributes.map { |a| row(a) }.join("\n  ")
      end

      def row(name)
        "#   row :#{name.gsub(/_id$/, '')}"
      end

      def columns
        attributes.map { |a| column(a) }.join("\n  ")
      end

      def column(name)
        "#   column :#{name.gsub(/_id$/, '')}"
      end

      def filters
        attributes.map { |a| filter(a) }.join("\n  ")
      end

      def filter(name)
        "# filter :#{name.gsub(/_id$/, '')}"
      end

      def form_inputs
        assignable_attributes.map { |a| form_input(a) }.join("\n  ")
      end

      def form_input(name)
        "#     f.input :#{name.gsub(/_id$/, '')}"
      end
    end
  end
end
