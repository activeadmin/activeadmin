module ActiveAdmin
  module Views

    class ActionItemsRenderer < ActiveAdmin::Renderer

      def to_html(action_items)
        content_tag :div, :class => 'action_items' do
          action_items.collect do |action_item|
            instance_eval(&action_item.block)
          end.join(" ").html_safe
        end
      end

    end

  end
end
