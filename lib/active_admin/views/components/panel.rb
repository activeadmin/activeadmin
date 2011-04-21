module ActiveAdmin
  module Views

    class Panel < ActiveAdmin::Component
      builder_method :panel

      def build(title, attributes = {})
        icon_name = attributes.delete(:icon)
        icn = icon_name ? icon(icon_name) : ""
        super(attributes)
        add_class "panel"
        @title = h3(icn + title.to_s)
        @contents = div(:class => "panel_contents")
      end

      def add_child(child)
        if @contents
          @contents << child
        else
          super
        end
      end
    end

  end
end
