# frozen_string_literal: true
require "active_admin/orm/active_record/comments/views"
require "active_admin/orm/active_record/comments/show_page_helper"
require "active_admin/orm/active_record/comments/namespace_helper"
require "active_admin/orm/active_record/comments/resource_helper"

# Add the comments configuration
ActiveAdmin::Application.inheritable_setting :comments, true
ActiveAdmin::Application.inheritable_setting :comments_registration_name, "Comment"
ActiveAdmin::Application.inheritable_setting :comments_order, "created_at ASC"
ActiveAdmin::Application.inheritable_setting :comments_menu, {}

# Insert helper modules
ActiveAdmin::Namespace.send :include, ActiveAdmin::Comments::NamespaceHelper
ActiveAdmin::Resource.send :include, ActiveAdmin::Comments::ResourceHelper
ActiveAdmin.application.view_factory.show_page.send :include, ActiveAdmin::Comments::ShowPageHelper

# Load the model as soon as it's referenced. By that point, Rails & Kaminari will be ready
ActiveAdmin.autoload :Comment, "active_admin/orm/active_record/comments/comment"

# Hint i18n-tasks about model and attribute translations used by default install
# i18n-tasks-use t('activerecord.models.comment')
# i18n-tasks-use t('activerecord.models.active_admin/comment')
# i18n-tasks-use t('activerecord.attributes.active_admin/comment.author_type')
# i18n-tasks-use t('activerecord.attributes.active_admin/comment.body')
# i18n-tasks-use t('activerecord.attributes.active_admin/comment.created_at')
# i18n-tasks-use t('activerecord.attributes.active_admin/comment.namespace')
# i18n-tasks-use t('activerecord.attributes.active_admin/comment.resource_type')
# i18n-tasks-use t('activerecord.attributes.active_admin/comment.updated_at')
# i18n-tasks-use t('active_admin.scopes.all')

# Walk through all the loaded namespaces after they're loaded
ActiveAdmin.after_load do |app|
  app.namespaces.each do |namespace|
    namespace.register ActiveAdmin::Comment, as: namespace.comments_registration_name do
      actions :index, :show, :create, :destroy

      menu namespace.comments ? namespace.comments_menu : false

      config.comments = false # Don't allow comments on comments
      config.batch_actions = false # The default destroy batch action isn't showing up anyway...

      scope :all, show_count: false
      # Register a scope for every namespace that exists.
      # The current namespace will be the default scope.
      app.namespaces.map(&:name).each do |name|
        scope name, default: namespace.name == name do |scope|
          scope.where namespace: name.to_s
        end
      end

      # Store the author and namespace
      before_save do |comment|
        comment.namespace = active_admin_config.namespace.name
        comment.author = current_active_admin_user
      end

      controller do
        # Prevent N+1 queries
        def scoped_collection
          super.includes(:author, :resource)
        end

        # Redirect to the resource show page after comment creation
        def create
          create! do |success, failure|
            success.html do
              redirect_back fallback_location: active_admin_root
            end
            failure.html do
              flash[:error] = I18n.t "active_admin.comments.errors.empty_text"
              redirect_back fallback_location: active_admin_root
            end
          end

          def destroy
            destroy! do |success, failure|
              success.html do
                redirect_back fallback_location: active_admin_root
              end
              failure.html do
                redirect_back fallback_location: active_admin_root
              end
            end
          end
        end
      end

      permit_params :body, :namespace, :resource_id, :resource_type

      index do
        column I18n.t("active_admin.comments.resource_type"), :resource_type
        column I18n.t("active_admin.comments.author_type"), :author_type
        column I18n.t("active_admin.comments.resource"), :resource
        column I18n.t("active_admin.comments.author"), :author
        column I18n.t("active_admin.comments.body"), :body
        column I18n.t("active_admin.comments.created_at"), :created_at
        actions
      end
    end
  end
end
