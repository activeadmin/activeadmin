module ActiveAdmin
  class Renderer
    module HTML

      class Element
		attr_accessor :parent, :document
        attr_reader :children

		def initialize
		  @children = Collection.new
		end

        def add_child(child)
          return unless child
          @children << child
          child.parent = self if child.respond_to?(:parent=)
        end
        alias :<< :add_child

        def build(*args)
        end

        def content=(string_contents)
          clear_children!
          add_child(string_contents)
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
