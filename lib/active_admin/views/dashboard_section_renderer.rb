module ActiveAdmin
  module Views
    class DashboardSection < ActiveAdmin::Views::Panel

      def build(section)
        @section = section
        super(title, :icon => @section.icon)
        instance_eval &@section.block
      end

      protected

      def title
        begin
          I18n.t!("active_admin.sections.#{@section.name.to_s}")
        rescue I18n::MissingTranslationData
          @section.name.to_s.titleize
        end		  
      end

    end
  end
end
