module ActiveAdmin
  module HTML

    def current_dom_context
      @__current_dom_element__ ||= Document.new
      @__current_dom_element__.current_dom_context
    end

    def method_missing(name, *args, &block)
      if current_dom_context.respond_to?(name)
        current_dom_context.send name, *args, &block
      else
        super
      end
    end

    module BuilderMethods
      def build_tag(klass, *args, &block)
        tag = klass.new

        # If you passed in a block and want the object
        if block_given? && block.arity > 0
          # Set out context to the tag, and pass responsibility to the tag
          with_current_dom_context tag do
            tag.build(*args, &block)
          end
        else
          # Build the tag
          tag.build(*args, &block)

          # Render the blocks contents
          if block_given?
            with_current_dom_context tag do
              insert_text_node_if_string(yield)
            end
          end
        end

        tag
      end

      def insert_tag(klass, *args, &block)
        tag = build_tag(klass, *args, &block)
        current_dom_context.add_child(tag)
        tag
      end

      def current_dom_context
        @__current_dom_element_buffer__ ||= [self]
        current_element = @__current_dom_element_buffer__.last
        if current_element == self
          self
        else
          current_element.current_dom_context
        end
      end

      def with_current_dom_context(tag)
        @__current_dom_element_buffer__.push tag
        yield
        @__current_dom_element_buffer__.pop
      end

      # Inserts a text node if the tag is a string
      def insert_text_node_if_string(tag)
        if tag.is_a?(String)
          current_dom_context << TextNode.from_string(tag)
        end
      end
    end

  end
end

require "active_admin/html/attributes.rb"
require "active_admin/html/core_extensions.rb"
require "active_admin/html/element"
require "active_admin/html/collection"
require "active_admin/html/tag"
require "active_admin/html/document"
require "active_admin/html/html5_elements"
require "active_admin/html/text_node"
