module ActiveAdmin
  module Pages
    class Index

      class Posts < PageConfig
        attr_accessor :title, :content

        def initialize(*args, &block)
          super
          block.call(Builder.new(self)) if block_given?
        end

        class Builder
          def initialize(posts_config)
            @posts_config = posts_config
          end

          def title(method = nil, &block)
            @posts_config.title = block_given? ? block : method
          end

          def content(method = nil, &block)
            @posts_config.content = block_given? ? block : method
          end
        end

        class Renderer < ::ActiveAdmin::Renderer

          def to_html(config, collection)
            @config = config
            wrap_with_pagination(collection, :entry_name => resource_name) do
              content_tag :div do
                collection.collect{|item| render_post(item) }.join
              end
            end
          end

          def title_content(post)
            call_method_or_proc_on(post, @config.title) || "#{resource_name} #{post.id}"
          end

          def content(post)
            call_method_or_proc_on(post, @config.content) || ""
          end

          def render_post(post)
            content_tag_for :div, post do
              title = content_tag :h3, link_to(title_content(post), resource_path(post))
              main_content = content_tag(:div, content(post), :class => 'content')
              title + main_content
            end
          end

        end
      end # Posts

    end
  end
end
