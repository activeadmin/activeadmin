module ActiveAdmin
  module Views
    class NewPage < BasePage

      def title
        "New #{active_admin_config.resource_name}"
      end

      def main_content
        p "Building main content"
        config = self.form_config.dup
        config.delete(:block)
        config.reverse_merge!({
          :url => collection_path
        })

        if form_config[:partial]
          text_node render(form_config[:partial])
        else
          text_node active_admin_form_for(resource, config, &form_config[:block])
        end
      end
    end

  end
end
