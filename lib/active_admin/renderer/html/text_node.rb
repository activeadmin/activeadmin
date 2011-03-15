module ActiveAdmin
  class Renderer
    module HTML

      class TextNode < Element

        def add_child(*args)
          raise "TextNodes do not have children"
        end

        def build(string)
          @content = string
        end

        def to_html
          @content.to_html
        end
      end

    end
  end
end
