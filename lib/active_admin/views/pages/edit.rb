module ActiveAdmin
  module Views
    module Pages
      class Edit < Base

        def title
          "Edit #{active_admin_config.resource_name}"
        end

        def main_content
          config = self.form_config.dup
          config.delete(:block)
          config.reverse_merge!({
            :url => resource_path(resource)
          })

          if form_config[:partial]
            render form_config[:partial]
          else
            active_admin_form_for resource, config, &form_config[:block]
          end
        end

      end
    end
  end
end
