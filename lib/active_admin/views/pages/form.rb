module ActiveAdmin
  module Views
    module Pages

      class Form < Base

        def title
          if form_presenter[:title]
            render_or_call_method_or_proc_on(resource, form_presenter[:title])
          else
            assigns[:page_title] || I18n.t("active_admin.#{normalized_action}_model",
                                      model: active_admin_config.resource_label)
          end
        end

        def form_presenter
          active_admin_config.get_page_presenter(:form) || default_form_config
        end

        def main_content
          options = default_form_options.merge form_presenter.options

          if options[:partial]
            render options[:partial]
          else
            active_admin_form_for resource, options, &form_presenter.block
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
          resource.persisted? ? resource_path(resource.id) : collection_path
        end

        def default_form_config
          ActiveAdmin::PagePresenter.new do |f|
            f.semantic_errors # show errors on :base by default
            f.inputs
            f.actions
          end
        end

        def normalized_action
          case params[:action]
          when "create"
            "new"
          when "update"
            "edit"
          else
            params[:action]
          end
        end
      end

    end
  end
end
