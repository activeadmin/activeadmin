module ActiveAdmin
  class ResourceController < ::InheritedViews::Base

    module Sidebars
      extend ActiveSupport::Concern

      included do
        self.class_inheritable_accessor :sidebar_sections
        self.sidebar_sections = []
      end

      module ClassMethods
        def sidebar(name, options = {}, &block)
          self.sidebar_sections << ActiveAdmin::Sidebar::Section.new(name, options, &block)
        end

        def clear_sidebar_sections!
          self.sidebar_sections = []
        end

        def sidebar_sections_for(action)
          sidebar_sections.select{|section| section.display_on?(action) }
        end
      end

      protected

      def skip_sidebar!
        @skip_sidebar = true
      end

      def skip_sidebar?
        @skip_sidebar == true
      end
    end

  end
end
