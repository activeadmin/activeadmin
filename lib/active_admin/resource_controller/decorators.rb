module ActiveAdmin
  class ResourceController < BaseController
    module Decorators
      protected

      def resource
        decorator = active_admin_config.decorator_class
        resource = super
        decorator ? decorator.new(resource) : resource
      end

      def active_admin_collection
        collection = super
        decorator ? collection_decorator.decorate(collection) : collection
      end

      private

      def collection_decorator
        decorator = active_admin_config.decorator_class
        decorator = collection_decorator_class_for(decorator)

        delegate_collection_methods(decorator)
      end

      def collection_decorator_class
        if decorator.respond_to?(:collection_decorator_class)
          # Draper >= 1.3.0
          decorator.collection_decorator_class
        elsif defined?(draper_collection_decorator) && decorator < draper_collection_decorator
          # Draper < 1.3.0
          draper_collection_decorator
        else
          # Not draper, probably really old versions of draper
          decorator
        end
      end

      # Create a new class that inherits from the collection decorator we are
      # using. We use this class to delegate collection scoping methods that
      # active_admin needs to render the table.
      #
      # TODO: This generated class should probably be cached.
      def delegate_collection_methods(decorator)
        return decorator unless decorator < draper_collection_decorator

        Class.new(decorator) do
          delegate :reorder, :page, :current_page, :total_pages,
                   :limit_value, :total_count, :num_pages, :to_key
        end
      end

      def draper_collection_decorator
        Draper::CollectionDecorator
      end

    end
  end
end
