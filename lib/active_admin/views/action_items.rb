module ActiveAdmin
  module Views

    class ActionItems < ActiveAdmin::Component

      def build(action_items)
        action_items.each do |action_item|
          instance_eval(&action_item.block)
        end
      end

    end

  end
end
