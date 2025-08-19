# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Active Admin"

      source_root File.expand_path("templates", __dir__)

      def generate_config_file
        template "resource.rb.erb", "app/admin/#{file_path.tr('/', '_').pluralize}.rb"
      end

      protected

      def attributes
        @attributes ||= class_name.constantize.new.attributes.keys
      end

      def primary_key
        @primary_key ||= [class_name.constantize.primary_key].flatten
      end

      def assignable_attributes
        @assignable_attributes ||= attributes - primary_key - %w(created_at updated_at)
      end

      def permit_params
        assignable_attributes.map { |a| a.to_sym.inspect }.join(", ")
      end

      def rows
        attributes.map { |a| row(a) }.join("\n      ")
      end

      def row(name)
        "row :#{name.gsub(/_id$/, '')}"
      end

      def columns
        (attributes - primary_key).map { |a| column(a) }.join("\n    ")
      end

      def column(name)
        "column :#{name.gsub(/_id$/, '')}"
      end

      def filters
        attributes.map { |a| filter(a) }.join("\n  ")
      end

      def filter(name)
        "filter :#{name.gsub(/_id$/, '')}"
      end

      def form_inputs
        assignable_attributes.map { |a| form_input(a) }.join("\n      ")
      end

      def form_input(name)
        "f.input :#{name.gsub(/_id$/, '')}"
      end
    end
  end
end
