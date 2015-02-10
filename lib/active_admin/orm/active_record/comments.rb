require 'active_admin/orm/active_record/comments/views'
require 'active_admin/orm/active_record/comments/show_page_helper'
require 'active_admin/orm/active_record/comments/namespace_helper'
require 'active_admin/orm/active_record/comments/resource_helper'

# Add the comments configuration
ActiveAdmin::Application.inheritable_setting :comments,                   true
ActiveAdmin::Application.inheritable_setting :show_comments_in_menu,      true
ActiveAdmin::Application.inheritable_setting :comments_registration_name, 'Comment'

# Insert helper modules
ActiveAdmin::Namespace.send :include, ActiveAdmin::Comments::NamespaceHelper
ActiveAdmin::Resource.send  :include, ActiveAdmin::Comments::ResourceHelper
ActiveAdmin.application.view_factory.show_page.send :include, ActiveAdmin::Comments::ShowPageHelper

# Load the model as soon as it's referenced. By that point, Rails & Kaminari will be ready
ActiveAdmin.autoload :Comment, 'active_admin/orm/active_record/comments/comment'

# Walk through all the loaded namespaces after they're loaded
ActiveAdmin.after_load do |app|
  app.namespaces.each do |namespace|
    namespace.register ActiveAdmin::Comment, as: namespace.comments_registration_name do
      actions :index, :show, :create

      menu false unless namespace.comments && namespace.show_comments_in_menu

      config.comments      = false # Don't allow comments on comments
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
        comment.author    = current_active_admin_user
      end

      controller do
        # Prevent N+1 queries
        def scoped_collection
          super.includes *( # rails/rails#14734
            ActiveAdmin::Dependency.rails?('>= 4.1.0', '<= 4.1.1') ?
              [:author] : [:author, :resource]
          )
        end

        # Redirect to the resource show page after comment creation
        def create
          create! do |success, failure|
            success.html{ redirect_to :back }
            failure.html do
              flash[:error] = I18n.t 'active_admin.comments.errors.empty_text'
              redirect_to :back
            end
          end
        end
      end

      # Set up permitted params in case the app is using Strong Parameters
      unless Rails::VERSION::MAJOR == 3 && !defined? StrongParameters
        permit_params :body, :namespace, :resource_id, :resource_type
      end

      index do
        column I18n.t('active_admin.comments.resource_type'), :resource_type
        column I18n.t('active_admin.comments.author_type'),   :author_type
        column I18n.t('active_admin.comments.resource'),      :resource
        column I18n.t('active_admin.comments.author'),        :author
        column I18n.t('active_admin.comments.body'),          :body
        actions
      end
    end
  end
end
