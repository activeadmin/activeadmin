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

    # 1. removes `select` and `order` to prevent invalid SQL
    # 2. correctly handles the Hash returned when `group by` is used
    def collection_size(c = collection)
      return c.count if c.is_a?(Array)
      return c.length if c.limit_value

      c = c.except :select, :order

      c.group_values.present? ? c.count.count : c.count
    end

    def collection_empty?(c = collection)
      collection_size(c) == 0
    end
  end
end
