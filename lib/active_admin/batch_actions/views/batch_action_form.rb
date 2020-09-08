require "active_admin/component"

module ActiveAdmin
  module BatchActions

    # Build a BatchActionForm
    class BatchActionForm < ActiveAdmin::Component
      builder_method :batch_action_form

      attr_reader :prefix_html

      def build(options = {}, &block)
        options[:id] ||= "collection_selection"

        # Open a form with two hidden input fields:
        # batch_action        => name of the specific action called
        # batch_action_inputs => a JSON string of any requested confirmation values
        text_node form_tag active_admin_config.route_batch_action_path(params, url_options), id: options[:id]
        input name: :batch_action, id: :batch_action, type: :hidden
        input name: :batch_action_inputs, id: :batch_action_inputs, type: :hidden

        super(options)
      end

      # Override the default to_s to include a closing form tag
      def to_s
        content + closing_form_tag
      end

      private

      def closing_form_tag
        "</form>".html_safe
      end

    end
  end
end
