module ActiveAdmin
  class Renderer
    module HTML

      class Document < Tag

        def document
          self
        end

        def tag_name
          'html'
        end

      end

    end
  end
end
