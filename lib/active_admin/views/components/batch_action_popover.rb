require 'active_admin/views/components/action_list_popover'

module ActiveAdmin
  module Views
    # Build an BatchActionPopover
    class BatchActionPopover < ActiveAdmin::Views::ActionListPopover
      builder_method :batch_action_popover
      
      def build(*args, &block)
        options = args.extract_options!
        options[:id] ||= "batch_actions_popover"
        super(options)
      end
      
      def action(batch_action, *args)
        options = args.extract_options!
        options[:class] ||= []
        options[:class] += %w(batch_action)
        super( "%s Selected" % batch_action.title, "#", options.merge( "data-action" => batch_action.sym, "data-request-confirm" => batch_action.confirm ) )
      end

    end
  end
end