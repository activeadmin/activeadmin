# frozen_string_literal: true
module ActiveAdmin
  module Views
    class CustomIndex < ActiveAdmin::Component

      def build(page_presenter, collection)
        add_class("custom-index")
        set_attribute("data-index-as", "custom")
        if active_admin_config.batch_actions.any?
          div class: "p-3" do
            resource_selection_toggle_panel
          end
        end

        div class: "p-3 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6" do
          collection.each do |obj|
            instance_exec(obj, &page_presenter.block)
          end
        end
      end

      def self.index_name
        "custom"
      end

    end
  end
end
