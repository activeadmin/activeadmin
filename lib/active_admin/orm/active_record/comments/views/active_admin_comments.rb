# frozen_string_literal: true
require_relative "../../../../views"

module ActiveAdmin
  module Comments
    module Views
      class Comments < Arbre::Element
        builder_method :active_admin_comments_for

        def build(resource)
          if authorized?(ActiveAdmin::Auth::READ, ActiveAdmin::Comment)
            comments = active_admin_authorization.scope_collection(ActiveAdmin::Comment.find_for_resource_in_namespace(resource, active_admin_namespace.name).includes(:author).page(params[:page]))
            render("active_admin/shared/resource_comments", resource: resource, comments: comments, comment_form_url: comment_form_url)
          end
        end

        protected

        def comment_form_url
          parts = []
          parts << active_admin_namespace.name unless active_admin_namespace.root?
          parts << active_admin_namespace.comments_registration_name.underscore.pluralize
          parts << "path"
          send parts.join "_"
        end
      end
    end
  end
end
