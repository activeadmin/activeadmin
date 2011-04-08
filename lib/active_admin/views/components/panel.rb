module ActiveAdmin
  module Views

    class Panel < ActiveAdmin::Component
      builder_method :panel

      def build(title, attributes = {})
        super(attributes)
        @title = h3(title)
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
