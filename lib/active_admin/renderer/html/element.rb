module ActiveAdmin
  class Renderer
    module HTML

      class Element
        include ::ActiveAdmin::Renderer::HTML
        include ::ActiveAdmin::Renderer::HTML::BuilderMethods
        
        attr_accessor :parent, :document
        attr_reader :children

        def initialize
          @children = Collection.new
        end

        def build(*args)
          # Render the block passing ourselves in
          insert_text_node_if_string(yield(self)) if block_given?
        end

        def add_child(child)
          return unless child

          if child.is_a?(String)
            child = TextNode.from_string(child)
          end

          if child.respond_to?(:parent)
            # Remove the child
            child.parent.remove_child(child) if child.parent
            # Set ourselves as the parent
            child.parent = self
          end

          @children << child
        end

        def remove_child(child)
          p "Removing child"
          child.parent = nil if child.respond_to?(:parent=)
          children.delete(child)
        end

        def <<(child)
          add_child(child)
        end

        def parent=(parent)
          @document = parent.respond_to?(:document) ? parent.document : nil
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
