module ActiveAdmin
  class Renderer
    module HTML

      class Element
        include ::ActiveAdmin::Renderer::HTML
        
        attr_accessor :parent, :document
        attr_reader :children

        def initialize
          @children = Collection.new
        end

        def build(*args)
        end

        def add_child(child)
          return unless child
          if child.is_a?(String)
            child = TextNode.from_string(child)
          end
          child.parent = self if child.respond_to?(:parent=)
          @children << child
        end
        alias :<< :add_child

        def parent=(parent)
          @document = parent.document if parent.respond_to?(:document)
          @parent = parent
        end

        def content=(string_contents)
          clear_children!
          add_child(ERB::Util.html_escape(string_contents)) if string_contents
        end

        def content
          @children.to_html
        end

        def to_s
          to_html
        end

        def to_html
          content
        end

        private

        # Resets the Elements children
        def clear_children!
          @children.clear
        end
      end

    end
  end
end
