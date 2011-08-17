require 'active_admin/comments/configuration'
require 'active_admin/comments/comment'
require 'active_admin/comments/views'
require 'active_admin/comments/show_page_helper'
require 'active_admin/comments/namespace_helper'
require 'active_admin/comments/resource_helper'

# Add the comments configuration
ActiveAdmin::Application.send :include, ActiveAdmin::Comments::Configuration

# Add the comments module to ActiveAdmin::Namespace
ActiveAdmin::Namespace.send :include, ActiveAdmin::Comments::NamespaceHelper

# Add the comments module to ActiveAdmin::Resource
ActiveAdmin::Resource.send :include, ActiveAdmin::Comments::ResourceHelper

# Add the module to the show page
ActiveAdmin.application.view_factory.show_page.send :include, ActiveAdmin::Comments::ShowPageHelper

# Generate a Comment resource when namespaces are registered
ActiveAdmin::Event.subscribe ActiveAdmin::Namespace::RegisterEvent do |namespace|
  if namespace.comments?
    namespace.register ActiveAdmin::Comment, :as => 'Comment' do
      actions :index, :show, :create

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
              flash[:error] = "Comment wasn't saved, text was empty."
              redirect_to send(resource_config.route_instance_path, @comment.resource)
            end
          end
        end
      end


      # Display as a table
      index do
        column("Resource"){|comment| auto_link(comment.resource) }
        column("Author"){|comment| auto_link(comment.author) }
        column :body
      end
    end
  end
end

# Register for comments when new resources are registered
ActiveAdmin::Event.subscribe ActiveAdmin::Resource::RegisterEvent do |resource|
  if resource.comments?
    resource.resource.has_many :active_admin_comments, :class_name => "ActiveAdmin::Comment",
                                                       :as         => :resource, 
                                                       :dependent  => :destroy
  end
end
