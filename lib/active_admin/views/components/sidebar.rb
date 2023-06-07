# frozen_string_literal: true
module ActiveAdmin
  module Views

    class Sidebar < Component
      builder_method :sidebar

      def build(sections, attributes = {})
        super(attributes)
        sections.map(&method(:sidebar_section))
      end
    end
  end
end
