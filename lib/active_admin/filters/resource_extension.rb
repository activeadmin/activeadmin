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
      end

      # Returns the filters for this resource. If filters are not enabled,
      # it will always return an empty array.
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

      # @return [Boolean] If filters are enabled for this resource
      def filters_enabled?
        @filters_enabled.nil? ? namespace.filters : @filters_enabled
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
      # @param [Symbol] attribute The attribute to not filter on
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
        default_association_filters + default_content_filters
      end

      # Returns a default set of filters for the associations
      def default_association_filters
        if resource_class.respond_to?(:reflect_on_all_associations)
          poly, not_poly = resource_class.reflect_on_all_associations.partition{ |r| r.macro == :belongs_to && r.options[:polymorphic] }

          # remove deeply nested associations
          not_poly.reject!{ |r| r.chain.length > 2 }

          filters = poly.map(&:foreign_type) + not_poly.map(&:name)
          filters.map &:to_sym
        else
          []
        end
      end

      # Returns a default set of filters for the content columns
      def default_content_filters
        if resource_class.respond_to? :content_columns
          resource_class.content_columns.map{ |c| c.name.to_sym }
        else
          []
        end
      end

      def add_filters_sidebar_section
        self.sidebar_sections << filters_sidebar_section
      end

      def filters_sidebar_section
        ActiveAdmin::SidebarSection.new :filters, only: :index, if: ->{ active_admin_config.filters.any? } do
          active_admin_filters_form_for assigns[:search], active_admin_config.filters
        end
      end

    end

  end
end
