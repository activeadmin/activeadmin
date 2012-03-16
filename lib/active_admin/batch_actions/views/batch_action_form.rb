require 'active_admin/component'

module ActiveAdmin
  module BatchActions

    # Build an BatchActionForm
    class BatchActionForm < ActiveAdmin::Component
      builder_method :batch_action_form

      attr_reader :prefix_html

      def build(options = {}, &block)
        options[:id] ||= "collection_selection"
        @contents = input(:name => :batch_action, :id => :batch_action, :type => :hidden)
        @prefix_html = text_node(form_tag send(active_admin_config.batch_action_path), :id => options[:id])
        super(options)
      end

      # Override to_html to wrap the custom form stuff
      def to_s
        @prefix_html + content + text_node('</form>'.html_safe)
      end

      def add_child(child)
        if @contents
          @contents << child
        else
          super
        end
      end

    end
  end
end
