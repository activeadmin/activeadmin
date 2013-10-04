module ActiveAdmin
  module BatchActions
    module Controller

      # Controller Action that get's called when submitting the batch action form
      def batch_action
        if selected_batch_action
          selected_ids = params[:collection_selection] || []
          instance_exec selected_ids, &selected_batch_action.block
        else
          raise "Couldn't find batch action \"#{params[:batch_action]}\""
        end
      end

      protected

      def selected_batch_action
        return unless params[:batch_action].present?
        active_admin_config.batch_actions.detect { |action| action.sym.to_s == params[:batch_action] }
      end

    end
  end
end
