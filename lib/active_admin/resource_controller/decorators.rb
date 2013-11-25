module ActiveAdmin
  class ResourceController < BaseController
    module Decorators
      protected

      def resource
        decorator = active_admin_config.decorator_class
        resource = super
        decorator ? decorator.new(resource) : resource
      end

      def collection
        @_decorated_collection ||= begin
          collection = super

          # WHY IS THE COLLECTION COMING IN ALREADY DECORATED?
          if collection.decorated?
            collection = collection.send(:object)
          end

          puts "collection: #{collection.inspect}"
          collection_decorator ? collection_decorator.decorate(collection) : collection
        end
      end

      private

      def collection_decorator
        decorator = active_admin_config.decorator_class
        decorator = collection_decorator_class_for(decorator)

        delegate_collection_methods(decorator)
      end

      def collection_decorator_class_for(decorator)
        puts "attempting to figure out what decorator class to use"

        if decorator.respond_to?(:collection_decorator_class)
          puts "using decorator.collection_decorator_class=#{decorator.collection_decorator_class.inspect}"
          # Draper >= 1.3.0
          decorator.collection_decorator_class
        elsif decorator && defined?(draper_collection_decorator) && decorator <= draper_collection_decorator
          puts "using draper_collection_decorator=#{draper_collection_decorator.inspect}"
          # Draper < 1.3.0
          draper_collection_decorator
        else
          puts "using the decorator itself: #{decorator.inspect}"
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
        puts "Attempting to delegate collection methods for #{decorator.inspect}"
        return decorator unless decorator && decorator <= draper_collection_decorator
        puts " YEP, we are using a custom class"

        Class.new(decorator) do
          delegate :reorder, :page, :current_page, :total_pages,
                   :limit_value, :total_count, :num_pages, :to_key

          def self.name
            "THIS IS A CUSTOM DECORATOR"
          end
        end
      end

      def draper_collection_decorator
        Draper::CollectionDecorator
      end

    end
  end
end
