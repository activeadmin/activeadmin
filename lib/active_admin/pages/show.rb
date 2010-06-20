module ActiveAdmin
  module Pages
    class Show < Base

      def title
        "#{resource_name} ##{resource.id}"
      end

      def main_content
        content_tag :dl, :id => "#{resource_class.name.underscore}_attributes", :class => "resource_attributes" do
          show_view_columns.collect do |attr|
            content_tag(:dt, attr.to_s.titlecase) + content_tag(:dd, resource.send(attr))
          end.join
        end
      end

    end
  end
end
