require 'active_admin/views'
require 'active_admin/views/components/panel'

module ActiveAdmin
  module Comments
    module Views

      class Comments < ActiveAdmin::Views::Panel
        builder_method :active_admin_comments_for

        def build(resource)
          @resource = resource
          @comments = ActiveAdmin::Comment.find_for_resource_in_namespace @resource, active_admin_namespace.name
          super(title, for: resource)
          build_comments
        end

        protected

        def title
          I18n.t 'active_admin.comments.title_content', count: @comments.count
        end

        def build_comments
          @comments.any? ? @comments.each(&method(:build_comment)) : build_empty_message
          build_comment_form
        end

        def build_comment(comment)
          div for: comment do
            div class: 'active_admin_comment_meta' do
              h4 class: 'active_admin_comment_author' do
                comment.author ? auto_link(comment.author) : I18n.t('active_admin.comments.author_missing')
              end
              span pretty_format comment.created_at
            end
            div class: 'active_admin_comment_body' do
              simple_format comment.body
            end
          end
        end

        def build_empty_message
          span I18n.t('active_admin.comments.no_comments_yet'), class: 'empty'
        end

        def comment_form_url
          parts = []
          parts << active_admin_namespace.name unless active_admin_namespace.root?
          parts << active_admin_namespace.comments_registration_name.underscore.pluralize
          parts << 'path'
          send parts.join '_'
        end

        def build_comment_form
          self << active_admin_form_for(ActiveAdmin::Comment.new, url: comment_form_url) do |f|
            f.inputs do
              f.input :resource_type, as: :hidden,  input_html: { value: ActiveAdmin::Comment.resource_type(@resource) }
              f.input :resource_id,   as: :hidden,  input_html: { value: @resource.id }
              f.input :body,          label: false, input_html: { size: '80x8' }
            end
            f.actions do
              f.action :submit, label: I18n.t('active_admin.comments.add')
            end
          end
        end

        def default_id_for_prefix
          'active_admin_comments_for'
        end
      end

    end
  end
end
