module ActiveAdmin
  module Views
    class DashboardPage < BasePage

      def main_content
        if @dashboard_sections && @dashboard_sections.any?
          render_sections(@dashboard_sections)
        else
          default_welcome_section
        end
      end

      protected

      # Dashboards don't have a sidebar
      def sidebar; end

      def title
        "Dashboard"
      end

      def render_sections(sections)
        content_tag :table, :class => "dashboard" do
          sections.in_groups_of(3, false).collect do |row|
            content_tag :tr do
              row.collect do |section| 
                content_tag :td, render_section(section)
              end.join.html_safe
            end
          end.join.html_safe
        end
      end

      # Renders each section using their renderer
      def render_section(section)
        renderer = section_renderer(section).new(self)
        renderer.to_html(section)
      end

      def section_renderer(section)
        if section.options[:as]
          view_factory["dashboard_section_as_#{section.options[:as]}"]
        else
          view_factory.dashboard_section
        end
      end

      def default_welcome_section
        content_tag :p, :id => "dashboard_default_message" do
          "Welcome to Active Admin. This is the default dashboard page. To add dashboard sections, checkout 'app/admin/dashboards.rb'"
        end
      end

    end
  end
end
