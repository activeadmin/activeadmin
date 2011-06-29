module ActiveAdmin
  module Views
    module Pages
      class Edit < Base

        def title
          I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name)
        end

        def main_content
          config = self.form_config.dup
          config.delete(:block)
          config.reverse_merge!({
            :url => resource_path(resource),
            :as => active_admin_config.underscored_resource_name
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
