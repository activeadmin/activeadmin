require 'active_admin/views'
require 'active_admin/views/components/panel'

module ActiveAdmin
  module Comments
    module Views

      class Comments < ActiveAdmin::Views::Panel
        builder_method :active_admin_comments_for

        def build(record)
          @record = record
          super(title_content, :for => record)
          build_comments
        end

        protected

        def title_content
          I18n.t('active_admin.comments.title_content', :count => record_comments.count)
        end

        def record_comments
          @record_comments ||= ActiveAdmin::Comment.find_for_resource_in_namespace(@record, active_admin_namespace.name)
        end

        def build_comments
          if record_comments.count > 0
            record_comments.each do |comment|
              build_comment(comment)
            end
          else
            build_empty_message
          end
          build_comment_form
        end

        def build_comment(comment)
          div :for => comment do
            div :class => "active_admin_comment_meta" do
              user_name = comment.author ? auto_link(comment.author) : "Anonymous"
              h4(user_name, :class => "active_admin_comment_author")
              span(pretty_format(comment.created_at))
            end
            div :class => "active_admin_comment_body" do
              simple_format(comment.body)
            end
            div :style => "clear:both;"
          end
        end

        def build_empty_message
          span :class => "empty" do
            I18n.t('active_admin.comments.no_comments_yet')
          end
        end

        def comment_form_url
          if active_admin_namespace.root?
            comments_path
          else
            send(:"#{active_admin_namespace.name}_comments_path")
          end
        end

        def build_comment_form
          self << active_admin_form_for(ActiveAdmin::Comment.new, :url => comment_form_url, :html => {:class => "inline_form"}) do |form|
            form.inputs do
              form.input :resource_type, :input_html => { :value => ActiveAdmin::Comment.resource_type(@record) }, :as => :hidden
              form.input :resource_id, :input_html => { :value => @record.id }, :as => :hidden
              form.input :body, :input_html => { :size => "80x8" }, :label => false
            end
            form.actions do
              form.action :submit, :label => I18n.t('active_admin.comments.add'), :button_html => { :value => I18n.t('active_admin.comments.add') }
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
