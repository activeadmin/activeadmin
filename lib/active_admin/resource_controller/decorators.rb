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
        decorator = active_admin_config.decorator_class
        collection = super
        decorator ? decorator.decorate_collection(collection) : collection
      end

    end
  end
end
