module ActiveAdmin
  module Views
    class DashboardSectionRenderer < ::ActiveAdmin::Renderer

      def to_html(section)
        @section = section
        content_tag :div, title_wrapped + content_wrapped, :class => 'dashboard_section', :id => "#{section.name.to_s.downcase.gsub(' ', '_')}_dashboard_section"
      end

      def title_wrapped
        content_tag :h3, icon + title
      end

      def icon
        if @section.icon
          ActiveAdmin::Iconic.icon(@section.icon)
        else
          ""
        end
      end

      def title
        @section.name.to_s.titleize
      end

      def content_wrapped
        content_tag :div, content, :class => 'dashboard_section_content'
      end

      def content
        instance_eval(&@section.block)
      end

    end
  end
end
