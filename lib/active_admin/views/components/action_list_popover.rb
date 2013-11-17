require 'active_admin/views/components/popover'

module ActiveAdmin
  module Views
    # Build an ActionListPopover
    class ActionListPopover < ActiveAdmin::Views::Popover
      builder_method :action_list_popover


      def build(*args, &block)
        @contents = ul :class => "popover_contents"

        options = args.extract_options!

        super(options)
      end

      def action(title, url, *args)
        options = args.extract_options!
        within @contents do
          li do
            text_node link_to( title, url, options )
          end
        end
      end

    end
  end
end
