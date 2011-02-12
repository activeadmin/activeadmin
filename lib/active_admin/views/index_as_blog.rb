module ActiveAdmin
  module Views
    class IndexAsBlog < Renderer

      def to_html(page_config, collection)
        @page_config = page_config
        @config = Builder.new
        @page_config.block.call(@config) if @page_config.block

        wrap_with_pagination(collection, :entry_name => active_admin_config.resource_name) do
          content_tag :div do
            collection.collect{|item| render_post(item) }.join.html_safe
          end
        end
      end

      private

      def render_post(post)
        content_tag_for :div, post do
          title = content_tag :h3, link_to(post_title_content(post), resource_path(post))
          main_content = content_tag(:div, post_content(post), :class => 'content')
          title + main_content
        end
      end

      def post_title_content(post)
        call_method_or_proc_on(post, @config.title) || "#{active_admin_config.resource_name} #{post.id}"
      end

      def post_content(post)
        call_method_or_proc_on(post, @config.content) || ""
      end


      # A small builder class which gets passed into the block when defining
      # the options to display as posts.
      #
      # ActiveAdmin.register Post
      #   index :as => :posts do |i|
      #     # i is an instance of Builder
      #   end
      # end
      class Builder
        def title(method = nil, &block)
          if block_given? || method
            @title = block_given? ? block : method
          end
          @title
        end

        def content(method = nil, &block)
          if block_given? || method
            @content = block_given? ? block : method
          end
          @content
        end
      end

    end # Posts
  end
end
