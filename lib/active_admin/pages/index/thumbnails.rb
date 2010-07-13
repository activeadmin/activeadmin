module ActiveAdmin
  module Pages
    class Index

      class Thumbnails < PageConfig
        attr_accessor :image

        def initialize(*args, &block)
          super
          block.call(Builder.new(self)) if block_given?
        end

        class Builder
          def initialize(posts_config)
            @thumbnails_config = posts_config
          end

          def image(method = nil, &block)
            @thumbnails_config.image = block_given? ? block : method
          end
        end

        class Renderer < ActiveAdmin::Renderer

          def to_html(config, collection)
            @config = config
            wrap_with_pagination(collection, :entry_name => resource_name) do
              content_tag :div, :style => "clear:both;" do
                collection.collect{|item| render_image(item) }.join
              end
            end
          end

          def render_image(item)
            link_to tag("img", :src => thumbnail_url(item), :width => 200, :height => 200),
                    resource_path(item)
          end

          def thumbnail_url(item)
            case @config.image
            when Symbol
              item.send @config.image
            when Proc
              setup_instance_variables(item)
              instance_eval(&@config.image)
            end
          end          
        end
      end

    end
  end
end
