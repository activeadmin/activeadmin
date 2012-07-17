module ActiveAdmin
  module Filters

    module ResourceExtension

      def initialize(*)
        super
        add_filters_sidebar_section
      end

      # Returns the filters for this resource. If filters are not enabled,
      # it will always return an empty array.
      #
      # @return [Array] Filters that apply for this resource
      def filters
        return [] unless filters_enabled?

        @filters || default_filters
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

      # Add a filter for this resource. If filters are not enabled, this method
      # will raise a RuntimeError
      #
      # @param [Symbol] attribute The attribute to filter on
      # @param [Hash] options The set of options that are passed through to 
      #                       metasearch for the field definition.
      def add_filter(attribute, options = {})
        unless filters_enabled?
          raise RuntimeError, "Can't add a filter when filters are disabled. Enable filters with 'config.filters = true'"
        end

        @filters ||= []

        @filters << options.merge({ :attribute => attribute })
      end

      # Reset the filters to use defaults
      def reset_filters!
        @filters = nil
      end

      private

      # @return [Array] The array of default for filters for this resource
      def default_filters
        default_association_filters + default_content_filters
      end

      # Returns a default set of filters for the associations
      def default_association_filters
        if resource_class.respond_to?(:reflections)
          resource_class.reflections.collect{|name, r| { :attribute => name }}
        else
          []
        end
      end

      # Returns a default set of filters for the content columns
      def default_content_filters
        if resource_class.respond_to?(:content_columns)
          resource_class.content_columns.collect{|c| { :attribute => c.name.to_sym } }
        else
          []
        end
      end

      def add_filters_sidebar_section
        self.sidebar_sections << filters_sidebar_section
      end

      def filters_sidebar_section
        ActiveAdmin::SidebarSection.new(:filters, :only => :index, :if => proc{ active_admin_config.filters.any? } ) do
          active_admin_filters_form_for assigns[:search], active_admin_config.filters
        end
      end

    end

  end
end
