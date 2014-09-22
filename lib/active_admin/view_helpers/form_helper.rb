module ActiveAdmin
  module ViewHelpers
    module FormHelper

      def active_admin_form_for(resource, options = {}, &block)
        Arbre::Context.new({}, self) do
          active_admin_form_for resource, options, &block
        end.content
      end

      def hidden_field_tags_for(params, options={})
        fields_for_params(params, options).map do |kv|
          k, v = kv.first
          hidden_field_tag k, v, id: sanitize_to_id("hidden_active_admin_#{k}")
        end.join("\n").html_safe
      end

    end
  end
end
