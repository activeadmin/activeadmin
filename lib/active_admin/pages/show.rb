module ActiveAdmin
  module Pages
    class Show < Base

      def title
        "#{resource_name} ##{resource.id}"
      end

      def main_content
        if controller.show_config
          instance_eval &controller.show_config
        else
          default_main_content
        end
      end
      
      def default_main_content
        table_options = {
          :border => 0, 
          :cellpadding => 0, 
          :cellspacing => 0,
          :id => "#{resource_class.name.underscore}_attributes",
          :class => "resource_attributes"
        }        
        content_tag :table, table_options do
          show_view_columns.collect do |attr|
            content_tag :tr do
              content_tag(:th, attr.to_s.titlecase) + content_tag(:td, resource.send(attr))
            end
          end.join
        end
      end

    end
  end
end
