module ActiveAdmin
  class ResourceController < BaseController
    module Decorators
      protected

      def apply_decorator(resource)
        decorate? ? decorator_class.new(resource) : resource
      end

      def apply_collection_decorator(collection)
        if decorate?
          collection_decorator.decorate(collection, with: decorator_class)
        else
          collection
        end
      end

      # TODO: find a more suitable place for this
      def self.undecorate_resource(resource)
        if resource.respond_to?(:decorated?) && resource.decorated?
          resource.model
        else
          resource
        end
      end

      private

      def decorate?
        case action_name
        when 'new', 'edit'
          form = active_admin_config.get_page_presenter :form
          form && form.options[:decorate] && decorator_class.present?
        else
          decorator_class.present?
        end
      end

      def decorator_class
        active_admin_config.decorator_class
      end

      def collection_decorator
        if decorator_class
          collection_decorator = collection_decorator_class_for(decorator_class)

          delegate_collection_methods_for_draper(collection_decorator, decorator_class)
        end
      end

      # Draper::CollectionDecorator was introduced in 1.0.0
      # Draper::Decorator#collection_decorator_class was introduced in 1.3.0
      def collection_decorator_class_for(decorator)
        if Dependencies.draper?    :>=, '1.3.0'
          decorator.collection_decorator_class
        elsif Dependencies.draper? :>=, '1.0.0'
          draper_collection_decorator
        else
          decorator
        end
      end

      def delegate_collection_methods_for_draper(collection_decorator, resource_decorator)
        return collection_decorator unless is_draper_collection_decorator?(collection_decorator)

        decorator_name = "#{collection_decorator.name} of #{resource_decorator} with ActiveAdmin extensions"
        decorator_class_cache[decorator_name] ||= generate_collection_decorator(collection_decorator, decorator_name)
      end

      # Create a new class that inherits from the collection decorator we are
      # using. We use this class to delegate collection scoping methods that
      # active_admin needs to render the table.
      def generate_collection_decorator(parent, name)
        klass = Class.new(parent) do
          delegate :reorder, :page, :current_page, :total_pages, :limit_value,
                   :total_count, :num_pages, :to_key, :group_values, :except
        end

        klass.define_singleton_method(:name) { name }

        klass
      end

      def decorator_class_cache
        @@decorator_class_cache ||= {}
      end

      def is_draper_collection_decorator?(decorator)
        decorator && decorator <= draper_collection_decorator
      rescue NameError
        false
      end

      def draper_collection_decorator
        Draper::CollectionDecorator
      end

    end
  end
end
