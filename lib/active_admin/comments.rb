require 'active_admin/comments/comment'
require 'active_admin/comments/views'
require 'active_admin/comments/show_page_helper'
require 'active_admin/comments/namespace_helper'
require 'active_admin/comments/resource_helper'

# Add the comments configuration
ActiveAdmin::Application.inheritable_setting :allow_comments, true

# Add the comments module to ActiveAdmin::Namespace
ActiveAdmin::Namespace.send :include, ActiveAdmin::Comments::NamespaceHelper

# Add the comments module to ActiveAdmin::Resource
ActiveAdmin::Resource.send :include, ActiveAdmin::Comments::ResourceHelper

# Add the module to the show page
ActiveAdmin.application.view_factory.show_page.send :include, ActiveAdmin::Comments::ShowPageHelper

# Walk through all the loaded resources after they are loaded
ActiveAdmin.after_load do |app|
  app.namespaces.values.each do |namespace|
    if namespace.comments?
      namespace.register ActiveAdmin::Comment, :as => "Comment" do
        actions :index, :show, :create

        # Ensure filters are turned on
        config.filters = true

        # Don't display in the menu
        menu false

        # Don't allow comments on comments
        config.comments = false

        # Filter Comments by date
        filter :resource_type
        filter :body
        filter :created_at

        # Only view comments in this namespace
        scope :all, :default => true do |comments|
          comments.where(:namespace => active_admin_config.namespace.name.to_s)
        end

        # Always redirect to the resource on show
        before_filter :only => :show do
          flash[:notice] = flash[:notice].dup if flash[:notice]
          comment = ActiveAdmin::Comment.find(params[:id])
          resource_config = active_admin_config.namespace.resource_for(comment.resource.class)
          redirect_to send(resource_config.route_instance_path, comment.resource)
        end

        # Store the author and namespace
        before_save do |comment|
          comment.namespace = active_admin_config.namespace.name
          comment.author = current_active_admin_user
        end

        # Redirect to the resource show page when failing to add a comment
        # TODO: Provide helpers to make such kind of customization much simpler
        controller do
          def create
            create! do |success, failure|
              failure.html do 
                resource_config = active_admin_config.namespace.resource_for(@comment.resource.class)
                flash[:error] = I18n.t('active_admin.comments.errors.empty_text')
                redirect_to send(resource_config.route_instance_path, @comment.resource)
              end
            end
          end
        end

        # Display as a table
        index do
          column(I18n.t('active_admin.comments.resource')){|comment| auto_link(comment.resource) }
          column(I18n.t('active_admin.comments.author')){|comment| auto_link(comment.author) }
          column(I18n.t('active_admin.comments.body')){|comment| comment.body }
        end
      end
    end
  end
end

# @deprecated #allow_comments_on - Remove in 0.5.0
ActiveAdmin::Application.deprecated_setting :allow_comments_in, [], 'The "allow_comments_in = []" setting is deprecated and will be remove by Active Admin 0.5.0. Please use "allow_comments = true|false" instead.'
