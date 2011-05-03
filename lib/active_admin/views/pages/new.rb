module ActiveAdmin
  module Views
    module Pages
      class New < Base

        def title
          "New #{active_admin_config.resource_name}"
        end

        def main_content
          config = self.form_config.dup
          config.delete(:block)
          config.reverse_merge!({
            :url => collection_path
          })

          if form_config[:partial]
            render(form_config[:partial])
          else
            active_admin_form_for(resource, config, &form_config[:block])
          end
        end
      end
    end

  end
end
