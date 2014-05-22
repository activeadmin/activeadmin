module ActiveAdmin
  module Views
    module Pages

      class Form < Base

        def title
          assigns[:page_title] || I18n.t("active_admin.#{params[:action]}_model",
                                         model: active_admin_config.resource_label)
        end

        def form_presenter
          active_admin_config.get_page_presenter(:form) || default_form_config
        end

        def main_content
          options = default_form_options.merge form_presenter.options

          if options[:partial]
            render options[:partial]
          else
            active_admin_form_for resource, options do |f|
              instance_exec f, &form_presenter.block
            end
          end
        end

        private

        def default_form_options
          {
            url: default_form_path,
            as: active_admin_config.param_key
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
