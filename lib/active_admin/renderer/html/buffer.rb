module ActiveAdmin
  class Renderer
    module HTML

      # An HTML buffer that wraps and buffers all the content
      # generated using the HTML builder methods.
      #
      # Each context where you include ActiveAdmin::Renderer::HTML 
      # generates a single Buffer and inserts tags into it.
      class Buffer

        def initialize
          @buffer = [Collection.new]
        end

        def insert(tag, *args)
          tag.document = self

          # Add the item
          current_buffer.push tag

          # Build the tag
          tag.build(*args)

          # Render the tag
          if block_given?
            children = with_new_buffer { yield } || []
            children.each do |child|
              tag << child
            end
          end

          # Return the item
          tag
        end

        def children
          @buffer.first
        end

        def to_html
          children.to_html
        end

        private

        def current_buffer
          @buffer.last
        end

        def with_new_buffer
          @buffer.push Collection.new

          # Yield the block
          rvalue = yield

          # If the block returns a string, we add it to the buffer
          if rvalue.is_a?(String)
            current_buffer.push rvalue 
          end

          # Return the buffer
          @buffer.pop
        end
      end

    end
  end
end
