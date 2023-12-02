# frozen_string_literal: true
module ActiveAdmin
  module Views
    class Sidebar < Component
      builder_method :sidebar

      def build(sections, attributes = {})
        super(attributes)
        add_class("sidebar")
        sections.map { |section| sidebar_section(section) }
      end
    end
  end
end
