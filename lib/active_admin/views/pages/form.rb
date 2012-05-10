module ActiveAdmin
  module Views
    module Pages

      class Form < Base

        def title
          I18n.t("active_admin.#{params[:action]}_model",
                 :model => active_admin_config.resource_label)
        end

        def form_presenter
            active_admin_config.get_page_presenter(:form) || default_form_config
        end

        def main_content
          form_options = default_form_options.merge(form_presenter.options)

          if form_options[:partial]
            render(form_options[:partial])
          else
            active_admin_form_for(resource, form_options) do |f|
              instance_exec f, &form_presenter.block
            end
          end
        end

        private

        def default_form_options
          {
            :url => default_form_path,
            :as => active_admin_config.resource_name.singular
          }
        end

        def default_form_path
          resource.persisted? ? resource_path(resource) : collection_path
        end

        def default_form_config
          ActiveAdmin::PagePresenter.new do |f|
            f.inputs
            f.actions
          end
        end
      end

    end
  end
end
