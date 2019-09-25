module ActiveAdmin
  module Filters

    class Disabled < RuntimeError
      def initialize
        super "Can't remove a filter when filters are disabled. Enable filters with 'config.filters = true'"
      end
    end

    module ResourceExtension

      def initialize(*)
        super
        add_filters_sidebar_section
        add_search_status_sidebar_section
      end

      # Returns the filters for this resource. If filters are not enabled,
      # it will always return an empty hash.
      #
      # @return [Hash] Filters that apply for this resource
      def filters
        filters_enabled? ? filter_lookup : {}
      end

      # Setter to enable / disable filters on this resource.
      #
      # Set to `nil` to inherit the setting from the namespace
      def filters=(bool)
        @filters_enabled = bool
      end

      # Setter to enable/disable showing current filters on this resource.
      #
      # Set to `nil` to inherit the setting from the namespace
      def current_filters=(bool)
        @current_filters_enabled = bool
      end

      # @return [Boolean] If filters are enabled for this resource
      def filters_enabled?
        @filters_enabled.nil? ? namespace.filters : @filters_enabled
      end

      # @return [Boolean] If show current filters are enabled for this resource
      def current_filters_enabled?
        @current_filters_enabled.nil? ? namespace.current_filters : @current_filters_enabled
      end

      def preserve_default_filters!
        @preserve_default_filters = true
      end

      def preserve_default_filters?
        @preserve_default_filters == true
      end

      # Remove a filter for this resource. If filters are not enabled, this method
      # will raise a RuntimeError
      #
      # @param [Symbol] attributes The attributes to not filter on
      def remove_filter(*attributes)
        raise Disabled unless filters_enabled?

        attributes.each { |attribute| (@filters_to_remove ||= []) << attribute.to_sym }
      end

      # Add a filter for this resource. If filters are not enabled, this method
      # will raise a RuntimeError
      #
      # @param [Symbol] attribute The attribute to filter on
      # @param [Hash] options The set of options that are passed through to
      #                       ransack for the field definition.
      def add_filter(attribute, options = {})
        raise Disabled unless filters_enabled?

        (@filters ||= {})[attribute.to_sym] = options
      end

      # Reset the filters to use defaults
      def reset_filters!
        @filters = nil
        @filters_to_remove = nil
      end

      private

      # Collapses the waveform, if you will, of which filters should be displayed.
      # Removes filters and adds in default filters as desired.
      def filter_lookup
        filters = @filters.try(:dup) || {}

        if filters.empty? || preserve_default_filters?
          default_filters.each do |f|
            filters[f] ||= {}
          end
        end

        if @filters_to_remove
          @filters_to_remove.each &filters.method(:delete)
        end

        filters
      end

      # @return [Array] The array of default filters for this resource
      def default_filters
        result = []
        result.concat default_association_filters if namespace.include_default_association_filters
        result.concat content_columns
        result.concat custom_ransack_filters
        result
      end

      def custom_ransack_filters
        if resource_class.respond_to?(:_ransackers)
          resource_class._ransackers.keys.map(&:to_sym)
        else
          []
        end
      end

      # Returns a default set of filters for the associations
      def default_association_filters
        if resource_class.respond_to?(:reflect_on_all_associations)
          poly, not_poly = resource_class.reflect_on_all_associations.partition { |r| r.macro == :belongs_to && r.options[:polymorphic] }

          # remove deeply nested associations
          not_poly.reject! { |r| r.chain.length > 2 }

          filters = poly.map(&:foreign_type) + not_poly.map(&:name)

          # Check high-arity associations for filterable columns
          max = namespace.maximum_association_filter_arity
          if max != :unlimited
            high_arity, low_arity = not_poly.partition do |r|
              r.klass.reorder(nil).limit(max + 1).count > max
            end

            # Remove high-arity associations with no searchable column
            high_arity = high_arity.select(&method(:searchable_column_for))

            high_arity = high_arity.map { |r| r.name.to_s + "_" + searchable_column_for(r) + namespace.filter_method_for_large_association }

            filters = poly.map(&:foreign_type) + low_arity.map(&:name) + high_arity
          end

          filters.map &:to_sym
        else
          []
        end
      end

      def search_columns
        @search_columns ||= namespace.filter_columns_for_large_association.map(&:to_s)
      end

      def searchable_column_for(relation)
        relation.klass.column_names.find { |name| search_columns.include?(name) }
      end

      def add_filters_sidebar_section
        self.sidebar_sections << filters_sidebar_section
      end

      def filters_sidebar_section
        ActiveAdmin::SidebarSection.new :filters, only: :index, if: -> { active_admin_config.filters.any? } do
          active_admin_filters_form_for assigns[:search], active_admin_config.filters
        end
      end

      def add_search_status_sidebar_section
        self.sidebar_sections << ActiveAdmin::Filters::ActiveSidebar.new
      end

    end

  end
end
