module ActiveAdmin
  class ResourceController < BaseController
    module Decorators
      protected

      def apply_decorator(resource)
        decorator_class ? decorator_class.new(resource) : resource
      end

      def apply_collection_decorator(collection)
        if (decorator = collection_decorator)
          decorator.decorate(collection, with: decorator_class)
        else
          collection
        end
      end

      private

      def decorator_class
        active_admin_config.decorator_class
      end

      def collection_decorator
        collection_decorator = collection_decorator_class_for(decorator_class)

        delegate_collection_methods_for_draper(collection_decorator, decorator_class)
      end

      def collection_decorator_class_for(decorator)
        if decorator.respond_to?(:collection_decorator_class)
          # Draper >= 1.3.0
          decorator.collection_decorator_class
        elsif decorator && defined?(draper_collection_decorator) && decorator <= draper_collection_decorator
          # Draper < 1.3.0
          draper_collection_decorator
        else
          # Not draper or maybe a really old version of draper
          decorator
        end
      end

      # Create a new class that inherits from the collection decorator we are
      # using. We use this class to delegate collection scoping methods that
      # active_admin needs to render the table.
      #
      # TODO: This generated class should probably be cached.
      def delegate_collection_methods_for_draper(collection_decorator, resource_decorator)
        return collection_decorator unless is_draper_collection_decorator?(collection_decorator)

        decorator_name = "#{collection_decorator.name} of #{resource_decorator} with ActiveAdmin extensions"

        cached = collection_decorator_class_cache[decorator_name]
        return cached if cached

        k = Class.new(collection_decorator) do
          delegate :reorder, :page, :current_page, :total_pages,
                   :limit_value, :total_count, :num_pages, :to_key
        end

        k.define_singleton_method :name do
          decorator_name
        end

        collection_decorator_class_cache[decorator_name] = k

        k
      end

      def collection_decorator_class_cache
        @@collection_decorator_class_cache ||= {}
      end

      def is_draper_collection_decorator?(decorator)
        decorator && decorator <= draper_collection_decorator
      end

      def draper_collection_decorator
        Draper::CollectionDecorator
      end

    end
  end
end
