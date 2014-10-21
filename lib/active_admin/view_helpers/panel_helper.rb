module ActiveAdmin
  module ViewHelpers
    module PanelHelper

      def panel(title, attributes = {}, &block)
        @panel ||= ActiveAdmin::Views::Panel.new
        @panel.panel title, attributes do
          content_tag(:div, &block) if block_given?
        end
      end

    end
  end
end
