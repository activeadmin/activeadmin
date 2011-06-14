module ActiveAdmin
  module Dashboards

    autoload :DashboardController,  'active_admin/dashboards/dashboard_controller'
    autoload :Section,              'active_admin/dashboards/section'

    @@sections = {}
    mattr_accessor :sections

    class << self

      # Eval an entire block in the context of this module to build 
      # dashboards quicker. 
      #
      # Example:
      #
      #   ActiveAdmin::Dashboards.build do
      #     section "Recent Post" do
      #       # return a list of posts
      #     end
      #   end
      #
      def build(&block)
        module_eval(&block)
      end

      # Add a new dashboard section to a namespace. If no namespace is given
      # it will be added to the default namespace.
      def add_section(name, options = {}, &block)
        namespace = options.delete(:namespace) || ActiveAdmin.application.default_namespace || :root
        self.sections[namespace] ||= [] 
        self.sections[namespace] << Section.new(namespace, name, options, &block)
        self.sections[namespace].sort!
      end
      alias_method :section, :add_section

      def sections_for_namespace(namespace)
        @@sections[namespace] || []
      end

      def clear_all_sections!
        @@sections = {}
      end

    end

  end
end
