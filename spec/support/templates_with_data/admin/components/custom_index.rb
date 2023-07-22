# frozen_string_literal: true
module ActiveAdmin
  module Views
    class CustomIndex < ActiveAdmin::Component

      def build(page_presenter, collection)
        add_class "index"
        resource_selection_toggle_panel if active_admin_config.batch_actions.any?
        collection.each do |obj|
          instance_exec(obj, &page_presenter.block)
        end
      end

      def self.index_name
        "custom"
      end

    end
  end
end
