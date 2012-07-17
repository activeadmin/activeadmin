module ActiveAdmin
  module Views

    class SidebarSection < Panel
      builder_method :sidebar_section

      # Takes a ActiveAdmin::Sidebar::Section instance
      def build(section)
        @section = section
        super(@section.title, :icon => @section.icon)
        self.id = @section.id
        build_sidebar_content
      end

      protected

      def build_sidebar_content
        if @section.block
          rvalue = instance_eval(&@section.block)
          self << rvalue if rvalue.is_a?(String)
        else
          render(@section.partial_name)
        end
      end
    end

  end
end
