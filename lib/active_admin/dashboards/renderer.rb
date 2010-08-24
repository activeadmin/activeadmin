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

      def render_section(section)
        title = content_tag :h3, section.name.to_s.titleize
        content = content_tag :div, instance_eval(&section.block), :class => 'dashboard_section', :id => "#{section.name.to_s.downcase.gsub(' ', '_')}_dashboard_section"
        title + content
      end

      def default_welcome_section
        content_tag :p, :id => "dashboard_default_message" do
          "Welcome to Active Admin. This is the default dashboard page. More details coming soon"
        end
      end

    end
  end
end
