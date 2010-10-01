module ActiveAdmin
  class ResourceController < ::InheritedViews::Base

    # Defined Callbacks
    #
    # == After Build
    # Called after the resource is built in the new and create actions.
    #
    # ActiveAdmin.register Post do
    #   after_build do |post|
    #     post.author = current_user
    #   end
    # end
    #
    # == Before / After Create
    # Called before and after a resource is saved to the db on the create action.
    #
    # == Before / After Update
    # Called before and after a resource is saved to the db on the update action.
    #
    # == Before / After Save
    # Called before and after the object is saved in the create and update action.
    # Note: Gets called after the create and update callbacks
    #
    # == Before / After Destroy
    # Called before and after the object is destroyed from the database.
    #
    module Callbacks
      extend ActiveSupport::Concern
      include ::ActiveAdmin::Callbacks

      included do
        define_active_admin_callbacks :build, :create, :update, :save, :destroy
      end

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
