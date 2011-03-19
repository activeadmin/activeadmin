module ActiveAdmin
  module Views

    class IndexAsThumbnails < Renderer

      def to_html(page_config, collection)
        @page_config = page_config
        @config = Builder.new
        @page_config.block.call(@config) if @page_config.block

        content_tag :div, :style => "clear:both;" do
          collection.collect{|item| render_image(item) }.join.html_safe
        end
      end

      def render_image(item)
        link_to tag("img", :src => thumbnail_url(item), :width => 200, :height => 200),
                resource_path(item)
      end

      def thumbnail_url(item)
        call_method_or_proc_on(item, @config.image)
      end          

      class Builder
        def image(method = nil, &block)
          if block_given? || method
            @image = block_given? ? block : method
          end
          @image
        end
      end

    end
  end
end
