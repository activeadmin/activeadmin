module ActiveAdmin
  module Dashboards

    autoload :DashboardController,  'active_admin/dashboards/dashboard_controller'
    autoload :Renderer,             'active_admin/dashboards/renderer'
    autoload :Section,              'active_admin/dashboards/section'
    autoload :SectionRenderer,      'active_admin/dashboards/section_renderer'

    @@sections = {}
    mattr_accessor :sections

    class << self
      def add_section(namespace, name, options = {}, &block)
       self.sections[namespace] ||= [] 
       self.sections[namespace] << Section.new(namespace, name, options, &block)
       self.sections[namespace].sort!
      end

      def sections_for_namespace(namespace)
        @@sections[namespace] || []
      end

      def clear_all_sections!
        @@sections = {}
      end
    end

  end
end
