module ActiveAdmin
  module SidebarForm
    module ResourceExtension
      def initialize(*)
        super
        add_sidebar_form_section
      end

      def add_sidebar_form
        @show_form_in_sidebar = true
      end

      def show_sidebar_form?
        @show_form_in_sidebar.present?
      end

      private

      def add_sidebar_form_section
        self.sidebar_sections << sidebar_form_section
      end

      def sidebar_form_section
        title = "new_#{resource_name.singular}".to_sym
        ActiveAdmin::SidebarSection.new title, only: :index, if: ->{ active_admin_config.show_sidebar_form? } do
          resource = @arbre_context.helpers.resource_class.new

          active_admin_form_for resource, options_for_form, &form_presenter.block
        end
      end
    end
  end
end
