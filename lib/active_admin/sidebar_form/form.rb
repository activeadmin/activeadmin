module ActiveAdmin
  module SidebarForm
    module Form

      private

      def options_for_form
        {
          url:               @arbre_context.helpers.collection_path,
          as:                active_admin_config.param_key,
          redirect_to_index: true
        }
      end

      def form_presenter
        active_admin_config.get_page_presenter(:form) || default_form_presenter
      end

      def default_form_presenter
        ActiveAdmin::PagePresenter.new do |f|
          f.semantic_errors
          f.inputs
          f.actions
        end
      end
    end
  end
end
