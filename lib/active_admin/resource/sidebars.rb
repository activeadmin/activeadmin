require 'active_admin/helpers/optional_display'

module ActiveAdmin

  class Resource
    module Sidebars

      def initialize(*args)
        super
        add_default_sidebar_sections
      end

      def sidebar_sections
        @sidebar_sections ||= []
      end

      def clear_sidebar_sections!
        @sidebar_sections = []
      end

      def sidebar_sections_for(action)
        sidebar_sections.select{|section| section.display_on?(action) }
      end

      def sidebar_sections?
        !!@sidebar_sections && @sidebar_sections.any?
      end

      private

      def add_default_sidebar_sections
        self.sidebar_sections << ActiveAdmin::SidebarSection.new(:filters, :only => :index) do
          active_admin_filters_form_for assigns["search"], filters_config
        end
      end

    end
  end

end
