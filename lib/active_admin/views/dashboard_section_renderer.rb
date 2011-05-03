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
        @section.name.to_s.titleize
      end

    end
  end
end
