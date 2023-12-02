# frozen_string_literal: true
require "active_admin/views"
require "active_admin/views/components/panel"

module ActiveAdmin
  module Comments
    module Views

      class Comments < ActiveAdmin::Views::Panel
        builder_method :active_admin_comments_for

        attr_accessor :resource

        def build(resource)
          if authorized?(ActiveAdmin::Auth::READ, ActiveAdmin::Comment)
            @resource = resource
            @comments = active_admin_authorization.scope_collection(ActiveAdmin::Comment.find_for_resource_in_namespace(resource, active_admin_namespace.name).includes(:author).page(params[:page]))
            super(title, for: resource)
            build_comments
          end
        end

        protected

        def default_class_name
          "comments"
        end

        def title
          I18n.t "active_admin.comments.title_content", count: @comments.total_count
        end

        def build_comments
          if authorized?(ActiveAdmin::Auth::NEW, ActiveAdmin::Comment)
            build_comment_form
          end

          if @comments.any?
            @comments.each { |comment| build_comment(comment) }
            div class: "paginated-collection-pagination" do
              div page_entries_info(@comments).html_safe
              options = { theme: :active_admin, outer_window: 1, window: 2 }
              text_node paginate(@comments, **options)
            end
          else
            build_empty_message
          end
        end

        def build_comment(comment)
          div id: dom_id_for(comment), class: "comment-container" do
            div class: "comment-header" do
              span class: "comment-author" do
                comment.author ? auto_link(comment.author) : I18n.t("active_admin.comments.author_missing")
              end
              span class: "comment-date" do
                pretty_format comment.created_at
              end
            end
            div class: "comment-body" do
              simple_format comment.body
            end
            if authorized?(ActiveAdmin::Auth::DESTROY, comment)
              text_node link_to I18n.t("active_admin.comments.delete"), comments_url(comment.id), method: :delete, data: { confirm: I18n.t("active_admin.comments.delete_confirmation") }
            end
          end
        end

        def build_empty_message
          span I18n.t("active_admin.comments.no_comments_yet"), class: "empty"
        end

        def comments_url(*args)
          parts = []
          parts << active_admin_namespace.name unless active_admin_namespace.root?
          parts << active_admin_namespace.comments_registration_name.underscore
          parts << "path"
          send parts.join("_"), *args
        end

        def comment_form_url
          parts = []
          parts << active_admin_namespace.name unless active_admin_namespace.root?
          parts << active_admin_namespace.comments_registration_name.underscore.pluralize
          parts << "path"
          send parts.join "_"
        end

        def build_comment_form
          active_admin_form_for(ActiveAdmin::Comment.new, url: comment_form_url, html: { class: "comment-form" }) do |f|
            f.inputs do
              f.input :resource_type, as: :hidden, input_html: { value: ActiveAdmin::Comment.resource_type(parent.resource) }
              f.input :resource_id, as: :hidden, input_html: { value: parent.resource.id }
              f.input :body, label: false, input_html: { size: "80x4" }
            end
            f.actions do
              f.action :submit, label: I18n.t("active_admin.comments.add")
            end
          end
        end

        def default_id_for_prefix
          "active_admin_comments_for"
        end
      end

    end
  end
end
