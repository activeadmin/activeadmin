# frozen_string_literal: true
module ActiveAdmin
  module IndexHelper
    def scope_name(scope)
      case scope.name
      when Proc then
        self.instance_exec(&scope.name).to_s
      else
        scope.name.to_s
      end
    end

    def batch_actions_to_display
      @batch_actions_to_display ||= begin
        if active_admin_config && active_admin_config.batch_actions.any?
          active_admin_config.batch_actions.select do |batch_action|
            call_method_or_proc_on(self, batch_action.display_if_block)
          end
        else
          []
        end
      end
    end
  end
end
