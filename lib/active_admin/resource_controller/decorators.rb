module ActiveAdmin
  class ResourceController < BaseController
    module Decorators

    protected

      def apply_decorator(resource)
        decorate? ? decorator_class.new(resource) : resource
      end

      def apply_collection_decorator(collection)
        if decorate?
          collection_decorator.decorate collection, with: decorator_class
        else
          collection
        end
      end

      def self.undecorate(resource)
        if resource.respond_to?(:decorated?) && resource.decorated?
          resource.model
        else
          resource
        end
      end

    private

      def decorate?
        case action_name
        when 'new', 'edit', 'create', 'update'
          form = active_admin_config.get_page_presenter :form
          form && form.options[:decorate] && decorator_class.present?
        else
          decorator_class.present?
        end
      end

      def decorator_class
        active_admin_config.decorator_class
      end

      # When using Draper, we wrap the collection draper in a new class that
      # correctly delegates methods that Active Admin depends on.
      def collection_decorator
        if decorator_class
          Wrapper.wrap decorator_class
        end
      end

      class Wrapper
        @cache = {}

        def self.wrap(decorator)
          collection_decorator = find_collection_decorator(decorator)

          if draper_collection_decorator? collection_decorator
            name = "#{collection_decorator.name} of #{decorator} + ActiveAdmin"
            @cache[name] ||= wrap! collection_decorator, name
          else
            collection_decorator
          end
        end

      private

        def self.wrap!(parent, name)
          ::Class.new parent do
            delegate :reorder, :page, :current_page, :total_pages, :limit_value,
                     :total_count, :num_pages, :to_key, :group_values, :except,
                     :find_each, :ransack

            define_singleton_method(:name) { name }
          end
        end

        # Draper::CollectionDecorator was introduced in 1.0.0
        # Draper::Decorator#collection_decorator_class was introduced in 1.3.0
        def self.find_collection_decorator(decorator)
          if Dependency.draper?    '>= 1.3.0'
            decorator.collection_decorator_class
          elsif Dependency.draper? '>= 1.0.0'
            draper_collection_decorator
          else
            decorator
          end
        end

        def self.draper_collection_decorator?(decorator)
          decorator && decorator <= draper_collection_decorator
        rescue NameError
          false
        end

        def self.draper_collection_decorator
          ::Draper::CollectionDecorator
        end

      end
    end
  end
end
