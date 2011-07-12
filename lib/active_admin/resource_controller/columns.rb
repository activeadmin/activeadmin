module ActiveAdmin
  class ResourceController < ::InheritedResources::Base

    module Columns
      ACTIVE_ADMIN_ACTIONS_FOR_COLUMNS = [:index, :show, :form]
      extend ActiveSupport::Concern

      included do
        helper_method :columns_config_for
      end

      module ClassMethods
        def column(attribute, options = {})
          return false if attribute.nil?
          @columns ||= []
          @columns << build_column(attribute, options)
        end

        def build_column(attribute, options)
          options[:attribute] = attribute
          options[:for]       = if only = options.delete(:only)
                                  Array(only)
                                elsif except = options.delete(:except)
                                  ACTIVE_ADMIN_ACTIONS_FOR_COLUMNS - Array(except)
                                else
                                  ACTIVE_ADMIN_ACTIONS_FOR_COLUMNS
                                end
          options
        end

        def columns_config_for(action)
          columns_for(action) || default_columns_config
        end

        def reset_columns!
          @columns = []
        end

        def columns_for(action)
          @columns.present? && @columns.collect{|hash| hash[:attribute] if hash[:for].include?(action) }.compact
        end

        # Returns a sane set of columns by default for the object
        def default_columns_config
          (association_columns(:belongs_to) + content_columns).compact
        end

        def association_columns(*by_associations) #:nodoc:
          if resource_class.respond_to?(:reflections)
            resource_class.reflections.collect do |name, association_reflection|
              if by_associations.present?
                name if by_associations.include?(association_reflection.macro)
              else
                name
              end
            end.compact
          else
            []
          end
        end

        def content_columns
          if resource_class.respond_to?(:content_columns)
            resource_class.content_columns.collect(&:name)
          else
            []
          end
        end
      end

      protected

      def columns_config_for(action)
        self.class.columns_config_for(action)
      end
    end

  end
end
