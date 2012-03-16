require 'active_admin/views/components/action_list_popover'

module ActiveAdmin
  module BatchActions
    # Build an BatchActionPopover
    class BatchActionPopover < ActiveAdmin::Views::ActionListPopover
      builder_method :batch_action_popover

      def build(options = {}, &block)
        options[:id] ||= "batch_actions_popover"
        super(options)
      end

      def action(batch_action, options = {})
        options[:class] ||= []
        options[:class] += %w(batch_action)
        options.merge! "data-action" => batch_action.sym,
                       "data-confirm" => batch_action.confirm

        title = I18n.t("active_admin.batch_actions.labels.#{batch_action.sym}", :default => batch_action.title)
        label = I18n.t("active_admin.batch_actions.action_label", :title => title)

        super(label, "#", options)
      end

    end
  end
end
