# frozen_string_literal: true
module ActiveAdmin
  module Views

    class ActionItems < ActiveAdmin::Component

      def build(action_items)
        action_items.each do |action_item|
          span class: action_item.html_class do
            instance_exec(&action_item.block)
          end
        end
      end

    end

  end
end
