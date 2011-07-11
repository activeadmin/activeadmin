module ActiveAdmin
  module Views
    module Pages
      class Dashboard < Base

        def main_content
          if assigns[:dashboard_sections] && assigns[:dashboard_sections].any?
            render_sections(assigns[:dashboard_sections])
          else
            default_welcome_section
          end
        end

        protected

        # Dashboards don't have a sidebar
        def build_sidebar; end

        def title
          I18n.t("active_admin.dashboard")
        end

        def render_sections(sections)
          table :class => "dashboard" do
            sections.in_groups_of(3, false).each do |row|
              tr do
                row.each do |section|
                  td do
                    render_section(section)
                  end
                end
              end
            end
          end
        end

        # Renders each section using their renderer
        def render_section(section)
          insert_tag section_renderer(section), section
        end

        def section_renderer(section)
          if section.options[:as]
            view_factory["dashboard_section_as_#{section.options[:as]}"]
          else
            view_factory.dashboard_section
          end
        end

        def default_welcome_section
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              span I18n.t('active_admin.dashboard_welcome.welcome')
              small I18n.t('active_admin.dashboard_welcome.call_to_action')
            end
          end
        end

      end
    end
  end
end
