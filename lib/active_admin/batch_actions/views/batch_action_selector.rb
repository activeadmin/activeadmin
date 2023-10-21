# frozen_string_literal: true
require "active_admin/component"

module ActiveAdmin
  module BatchActions
    class BatchActionSelector < ActiveAdmin::Component
      builder_method :batch_action_selector

      # Build a new batch actions selector
      #
      # @param [Array] batch_actions An array of batch actions
      def build(batch_actions)
        @batch_actions = Array(batch_actions)
        @drop_down = build_drop_down
      end

      # We don't want to wrap the action list (or any other children) in
      # an unnecessary div, so instead we just return the children
      def to_s
        children.to_s
      end

      private

      def build_drop_down
        return if batch_actions_to_display.empty?
        svg = '<svg class="dropdown-menu-button-arrow" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/></svg>'

        dropdown_menu (I18n.t("active_admin.batch_actions.button_label") + svg).html_safe,
                      class: "batch_actions_selector dropdown_menu",
                      button: { disabled: "disabled" } do
          batch_actions_to_display.each do |batch_action|
            confirmation_text = render_or_call_method_or_proc_on(self, batch_action.confirm)

            options = {
              "data-action": batch_action.sym,
              "data-confirm": confirmation_text.presence,
              "data-batch-action-item": "data-batch-action-item"
            }.compact.reverse_merge(batch_action.link_html_options)

            default_title = render_or_call_method_or_proc_on(self, batch_action.title)
            title = I18n.t("active_admin.batch_actions.labels.#{batch_action.sym}", default: default_title)
            label = I18n.t("active_admin.batch_actions.action_label", title: title)

            item label, "#", **options
          end
        end
      end

      # Return the set of batch actions that should be displayed
      def batch_actions_to_display
        @batch_actions.select do |batch_action|
          call_method_or_proc_on(self, batch_action.display_if_block)
        end
      end
    end
  end
end
