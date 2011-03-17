class Object
  def to_html
    to_s
  end
end

require "active_admin/renderer/html/document"
require "active_admin/renderer/html/element"
require "active_admin/renderer/html/collection"
require "active_admin/renderer/html/tag"
require "active_admin/renderer/html/text_node"

module ActiveAdmin
  class Renderer
    module HTML

      def __current_html_document__
        @__current_html_document__ ||= Document.new
      end

      [:span, :li, :ul].each do |name|
        class_eval <<-EOF, __FILE__, __LINE__
          def #{name}(*args, &block)
            __current_html_document__.insert Tag.new(:#{name}), *args, &block
          end
        EOF
      end

    end
  end
end
