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
            case @config.title
            when Symbol
              post.send @config.title
            when Proc
              instance_exec(post, &@config.title)
            else
              "#{resource_name} #{post.id}"
            end
          end

          def content(post)
            case @config.content
            when Symbol
              post.send @config.content
            when Proc
              instance_exec(post, &@config.content)
            else
              ""
            end            
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
