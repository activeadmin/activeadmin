module ActiveAdmin

  class Resource
    module Attributes

      def default_attributes
        resource_class.columns.each_with_object({}) do |c, attrs|
          unless reject_col?(c)
            name = c.name.to_sym
            attrs[name] = (method_for_column(name) || name)
          end
        end
      end

      def method_for_column(c)
        resource_class.respond_to?(:reflect_on_all_associations) && foreign_methods.has_key?(c) && foreign_methods[c].name.to_sym
      end

      def foreign_methods
        @foreign_methods ||= resource_class.reflect_on_all_associations.
          select { |r| r.macro == :belongs_to }.
          reject { |r| r.chain.length > 2 && !r.options[:polymorphic] }.
          index_by { |r| r.foreign_key.to_sym }
      end

      def reject_col?(c)
        primary_col?(c) || sti_col?(c) || counter_cache_col?(c) || filtered_col?(c)
      end

      def primary_col?(c)
        c.name == resource_class.primary_key
      end

      def sti_col?(c)
        c.name == resource_class.inheritance_column
      end

      def counter_cache_col?(c)
        c.name.end_with?("_count")
      end

      def filtered_col?(c)
        ActiveAdmin.application.filter_attributes.include?(c.name.to_sym)
      end
    end
  end
end
