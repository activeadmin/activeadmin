module ActiveAdmin
  module Views
    # Build an BatchActionForm
    class BatchActionForm < ActiveAdmin::Component
      builder_method :batch_action_form
      
      attr_reader :prefix_html
      
      def build(*args, &block)
        options = args.extract_options!
        options[:id] ||= "collection_selection"
        @prefix_html = text_node(form_tag active_admin_config.batch_action_path, :id => options[:id])
        super(options)
      end
      
      # Override to_html to wrap the custom form stuff
      def to_html
        @prefix_html + content + text_node('</form>'.html_safe)
      end

    end
  end
end