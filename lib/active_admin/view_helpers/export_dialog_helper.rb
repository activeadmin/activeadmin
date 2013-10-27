module ActiveAdmin
  module ViewHelpers
    module ExportDialogHelper

      def build_export_dialog
        div :id => "export_dialog", :title => "Export Data", :style => "display: none;" do
          build_export_form
        end
      end

      def build_export_form
        active_admin_form_for :export do |f|
          f.inputs do
            f.input :start, :as => :string
            f.input :end,   :as => :string
          end
        end
      end

    end
  end
end

