module ActiveAdmin
  class ResourceController < BaseController

    module Filters
      extend ActiveSupport::Concern

      included do
        helper_method :filters_config
      end

      module ClassMethods
        def filter(attribute, options = {})
          return false if attribute.nil?
          @filters ||= []
          @filters << options.merge(:attribute => attribute)
        end

        def default_filters
          @default_filters_display = true
        end

        def filters_config
          if @filters && @filters.any? && !@default_filters_display
            @filters
          elsif @filters && @filters.any?
            @filters + default_filters_config
          else
            default_filters_config
          end
        end

        def reset_filters!
          @filters = []
        end

        # Returns a sane set of filters by default for the object
        def default_filters_config
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
      end

      protected

      def filters_config
        self.class.filters_config
      end
    end

  end
end
