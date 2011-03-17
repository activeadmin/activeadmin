module ActiveAdmin
  class Renderer
    module HTML

      class Document

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
              case child
              when String
                tn = TextNode.new
                tn.build(child)
                child = tn
              end
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
            node = TextNode.new
            node.build(rvalue)
            current_buffer.push node 
          end

          # Return the buffer
          @buffer.pop
        end
      end

    end
  end
end
