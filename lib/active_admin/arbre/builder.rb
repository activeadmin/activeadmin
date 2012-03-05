module Arbre

  # Include this module in any context to start building html.
  #
  #   assigns = {}
  #   include Arbre::Builder
  #   span("foo").to_s #=> "<span>foo</span>
  #
  # When you include the module, you are required to setup 2 variables:
  #
  # * assigns: This is a hash that includes local variables
  # * helpers: This is an object that provides helper methods to all
  #              objects within the context.
  module Builder

    # Retrieve the current DOM context.
    #
    # If no `@__current_dom_element__` has been set, this method will
    # setup the initial context.
    #
    # @return [Arbre::Element] the current element that is in context
    def current_dom_context
      @__current_dom_element__ ||= Arbre::Context.new(assigns, helpers)
      @__current_dom_element__.current_dom_context
    end

    def helpers
      @_helpers
    end

    # Implements the method lookup chain. When you call a method that
    # doesn't exist, we:
    #
    #  1. Try to call the method on the current DOM context
    #  2. Return an assigned variable of the same name
    #  3. Call the method on the helper object
    #  4. Call super
    #
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
              append_return_block(yield)
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

      # Appends the value to the current DOM element if there are no
      # existing DOM Children and it responds to #to_s
      def append_return_block(tag)
        return nil if current_dom_context.children?

        if appendable_return_block?(tag)
          current_dom_context << Arbre::HTML::TextNode.from_string(tag.to_s)
        end
      end
      
      def appendable_return_block?(tag)
        appendable = !tag.is_a?(Arbre::HTML::Element) && tag.respond_to?(:to_s) 
        
        # Ruby 1.9 returns empty array as "[]"
        if tag.respond_to?(:empty?) && tag.empty? 
          appendable = false
        end
        
        appendable
      end
    end

  end
end

