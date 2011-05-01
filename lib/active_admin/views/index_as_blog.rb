module ActiveAdmin
  module Views
    class IndexAsBlog < ActiveAdmin::Component

      def build(page_config, collection)
        @page_config = page_config
        @collection = collection

        # Call the block passed in. This will set the 
        # title and body methods
        instance_eval &page_config.block if page_config.block

        build_posts
      end

      # Setter method for the configuration of the title
      #
      #   index :as => :blog do
      #     title :a_method_to_call #=> Calls #a_method_to_call on the resource
      #
      #     # OR
      #
      #     title do |post|
      #       post.a_method_to_call
      #     end
      #   end
      def title(method = nil, &block)
        if block_given? || method
          @title = block_given? ? block : method
        end
        @title
      end

      # Setter method for the configuration of the body
      #
      #   index :as => :blog do
      #     title :my_title
      #
      #     body :a_method_to_call #=> Calls #a_method_to_call on the resource
      #
      #     # OR
      #
      #     title do |post|
      #       post.a_method_to_call
      #     end
      #   end
      def body(method = nil, &block)
        if block_given? || method
          @body = block_given? ? block : method
        end
        @body
      end

      private

      def build_posts
        @collection.each do |post|
          build_post(post)
        end
      end

      def build_post(post)
        div :for => post do
          build_title(post)
          build_body(post)
        end
      end

      def build_title(post)
        if @title
          h3 do
            link_to(call_method_or_proc_on(post, @title), resource_path(post))
          end
        else
          h3 do
            auto_link(post)
          end
        end
      end

      def build_body(post)
        if @body
          div(call_method_or_proc_on(post, @body), :class => 'content')
        end
      end

    end # Posts
  end
end
