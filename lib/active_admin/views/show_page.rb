module ActiveAdmin
  module Views
    class ShowPage < BasePage

      def config
        active_admin_config.page_configs[:show] || ::ActiveAdmin::PageConfig.new
      end

      def title
        case config[:title]
        when Symbol, Proc
          call_method_or_proc_on(resource, config[:title])
        when String
          config[:title]
        else
          default_title
        end
      end

      def main_content
        if config.block
          # Eval the show config from the controller
          instance_eval &config.block
        else
          default_main_content
        end
        html = current_dom_context.document.content.html_safe
        html + (comments if active_admin_config.admin_notes?)
      end

      def comments
        render view_factory.admin_notes, resource
      end

      def attributes_table(*args, &block)
        attributes_table_for resource, *args, &block
      end

      protected

      def default_title
        "#{active_admin_config.resource_name} ##{resource.id}"
      end

      def default_main_content
        attributes_table *show_view_columns
      end
    end
  end
end
