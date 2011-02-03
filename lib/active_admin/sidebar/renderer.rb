module ActiveAdmin
  module Sidebar

    # Renders the an array of sidebar sections
    class Renderer < ActiveAdmin::Renderer
      def to_html(sidebar_sections)
        sidebar_sections.collect do |section|
          title   = content_tag :h3, section.title
          content = content_tag :div, sidebar_content(section)

          content_tag :div, :class => 'sidebar_section', :id => section.id do
            title + content
          end
        end.join.html_safe
      end

      # If a block exists, render the block. Otherwise render a partial
      def sidebar_content(section)
        if section.block
          instance_eval(&section.block)
        else
          capture do
            render section.partial_name
          end
        end
      end
    end

  end
end
