require 'active_admin/component'

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
      # an unecessary div, so instead we just return the children
      def to_s
        children.to_s
      end

      private

      def build_drop_down
        dropdown_menu I18n.t("active_admin.batch_actions.button_label"),
                      :id => "batch_actions_selector",
                      :button => { :class => "disabled" } do
          batch_actions_to_display.each do |batch_action|
            confirmation_text = render_or_call_method_or_proc_on(self, batch_action.confirm)

            options = {
              :class => "batch_action",
              "data-action" => batch_action.sym,
              "data-confirm" => confirmation_text
            }

            default_title = render_or_call_method_or_proc_on(self, batch_action.title)
            title = I18n.t("active_admin.batch_actions.labels.#{batch_action.sym}", :default => default_title)
            label = I18n.t("active_admin.batch_actions.action_label", :title => title)

            item label, "#", options
          end
        end
      end

      # Return the set of batch actions that should be displayed
      def batch_actions_to_display
        @batch_actions.select do |batch_action|
          call_method_or_proc_on(self, batch_action.display_if_block)
        end
      end

      # def build_batch_action_button
      #   a :class => 'table_tools_button dropdown_button disabled', :href => "#batch_actions_popover", :id => "batch_actions_button" do
      #     text_node I18n.t("active_admin.batch_actions.button_label")
      #   end
      # end

      # def build_batch_action_popover
      # end

    end

  end
end
