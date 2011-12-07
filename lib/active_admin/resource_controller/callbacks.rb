module ActiveAdmin
  class ResourceController < BaseController

    module Callbacks
      extend ActiveSupport::Concern
      include ::ActiveAdmin::Callbacks

      included do
        define_active_admin_callbacks :build, :create, :update, :save, :destroy
      end

      protected

      def build_resource
        object = super
        run_build_callbacks object
        object
      end

      def create_resource(object)
        run_create_callbacks object do
          save_resource(object)
        end
      end

      def save_resource(object)
        run_save_callbacks object do
          object.save
        end
      end

      def update_resource(object, attributes)
        object.attributes = attributes
        run_update_callbacks object do
          save_resource(object)
        end
      end

      def destroy_resource(object)
        run_destroy_callbacks object do
          object.destroy
        end
      end
    end

  end
end
