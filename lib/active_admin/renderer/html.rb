require "active_admin/renderer/html/attributes.rb"
require "active_admin/renderer/html/core_extensions.rb"
require "active_admin/renderer/html/buffer"
require "active_admin/renderer/html/element"
require "active_admin/renderer/html/collection"
require "active_admin/renderer/html/tag"
require "active_admin/renderer/html/html5_elements"
require "active_admin/renderer/html/text_node"

module ActiveAdmin
  class Renderer
    module HTML

      def __current_html_document__
        @__current_html_document__ ||= Buffer.new
      end

    end
  end
end
