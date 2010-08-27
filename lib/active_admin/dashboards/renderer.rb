module ActiveAdmin
  module Dashboards
    class Renderer < ::ActiveAdmin::Pages::Base

      def main_content
        if @dashboard_sections && @dashboard_sections.any?
          render_sections(@dashboard_sections)
        else
          default_welcome_section
        end
      end

      protected

      def title
        "Dashboard"
      end

      def render_sections(sections)
        content_tag :table, :class => "dashboard" do
          sections.in_groups_of(3, false).collect do |row|
            content_tag :tr do
              row.collect do |section| 
                content_tag :td, render_section(section)
              end.join
            end
          end.join
        end
      end

      # Renders each section using their renderer
      def render_section(section)
        renderer = section.renderer.new(self)
        renderer.to_html(section)
      end

      def default_welcome_section
        content_tag :p, :id => "dashboard_default_message" do
          "Welcome to Active Admin. This is the default dashboard page. More details coming soon"
        end
      end

    end
  end
end
