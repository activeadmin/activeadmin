module ActiveAdmin
  module Views

    # Renders the an array of sidebar sections
    class SidebarRenderer < ActiveAdmin::Renderer

      def to_html(sidebar_sections)
        sidebar_sections.collect do |section|
          sidebar_section(section)
        end
        current_dom_context.document.content
      end
    end

  end
end
