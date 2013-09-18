module ActiveAdmin
  module BatchActions
    module Controller

      # Controller action that is called when submitting the batch action form
      def batch_action
        if action_present?
          selection =            params[:collection_selection] ||  []
          inputs    = JSON.parse params[:batch_action_inputs]  || '{}'
          inputs    = inputs.with_indifferent_access.slice *current_batch_action.inputs.keys
          instance_exec selection, inputs, &current_batch_action.block
        else
          raise "Couldn't find batch action \"#{params[:batch_action]}\""
        end
      end

      protected

      def action_present?
        params[:batch_action].present? && current_batch_action
      end

      def current_batch_action
        active_admin_config.batch_actions.detect{ |action| action.sym.to_s == params[:batch_action] }
      end

    end
  end
end
