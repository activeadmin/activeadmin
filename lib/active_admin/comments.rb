require 'active_admin/comments/configuration'
require 'active_admin/comments/comment'
require 'active_admin/comments/views'
require 'active_admin/comments/show_page_helper'
require 'active_admin/comments/namespace_helper'
require 'active_admin/comments/resource_helper'

# Add the comments configuration
ActiveAdmin.extend ActiveAdmin::Comments::Configuration

# Add the comments module to ActiveAdmin::Namespace
ActiveAdmin::Namespace.send :include, ActiveAdmin::Comments::NamespaceHelper

# Add the comments module to ActiveAdmin::Resource
ActiveAdmin::Resource.send :include, ActiveAdmin::Comments::ResourceHelper

# Add the module to the show page
ActiveAdmin.view_factory.show_page.send :include, ActiveAdmin::Comments::ShowPageHelper

# Generate a Comment resource when namespaces are registered
ActiveAdmin::Event.subscribe ActiveAdmin::Namespace::RegisterEvent do |namespace|
  if namespace.comments?
    namespace.register ActiveAdmin::Comment, :as => 'Comment' do

      # Don't display in the menu
      menu false

      # Don't allow comments on comments
      config.comments = false

      # Always redirect to the resource on show
      before_filter :only => :show do
        flash[:notice] = flash[:notice].dup if flash[:notice]
        comment = ActiveAdmin::Comment.find(params[:id])
        redirect_to [active_admin_config.namespace.name, comment.resource]
      end

      before_save do |comment|
        comment.namespace = active_admin_config.namespace.name
        comment.author = current_active_admin_user
      end
    end
  end
end

# Register for comments when new resources are registered
ActiveAdmin::Event.subscribe ActiveAdmin::Resource::RegisterEvent do |resource|
  if resource.comments?
    resource.resource.has_many :active_admin_comments, :class_name => "ActiveAdmin::Comment",
                                                       :as         => :resource
  end
end
