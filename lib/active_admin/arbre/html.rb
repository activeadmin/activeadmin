module Arbre
  module HTML
    def current_dom_context
      @__current_dom_element__ ||= Arbre::Context.new(assigns, helpers)
      @__current_dom_element__.current_dom_context
    end

    def helpers
      @_helpers
    end

    def method_missing(name, *args, &block)
      if current_dom_context.respond_to?(name)
        current_dom_context.send name, *args, &block
      elsif assigns && assigns.has_key?(name)
        assigns[name]
      elsif helpers.respond_to?(name)
        helpers.send(name, *args, &block)
      else
        super
      end
    end

    module BuilderMethods
      def build_tag(klass, *args, &block)
        tag = klass.new(assigns, helpers)

        # If you passed in a block and want the object
        if block_given? && block.arity > 0
          # Set out context to the tag, and pass responsibility to the tag
          with_current_dom_context tag do
            tag.build(*args, &block)
          end
        else
          # Build the tag
          tag.build(*args)

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
        raise ArgumentError, "Can't be in the context of nil. #{@__current_dom_element_buffer__.inspect}" unless tag
        current_dom_context # Ensure a context is setup
        @__current_dom_element_buffer__.push tag
        yield
        @__current_dom_element_buffer__.pop
      end
      alias_method :within, :with_current_dom_context

      # Inserts a text node if the tag is a string
      def insert_text_node_if_string(tag)
        if tag.is_a?(String)
          current_dom_context << TextNode.from_string(tag)
        end
      end
    end

  end
end

