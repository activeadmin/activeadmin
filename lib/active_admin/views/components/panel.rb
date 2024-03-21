# frozen_string_literal: true
module ActiveAdmin
  module Views

    class Panel < ActiveAdmin::Component
      builder_method :panel

      def build(title, attributes = {})
        super(attributes)
        add_class "panel"
        @title = h3(title.to_s, class: "panel-title")
        @contents = div(class: "panel-body")
      end

      def add_child(child)
        if @contents
          @contents << child
        else
          super
        end
      end

      # Override children? to only report children when the panel's
      # contents have been added to. This ensures that the panel
      # correctly appends string values, etc.
      def children?
        @contents.children?
      end
    end
  end
end
