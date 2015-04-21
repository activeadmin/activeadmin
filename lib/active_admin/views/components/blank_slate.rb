module ActiveAdmin
  module Views
    # Build a Blank Slate
    class BlankSlate < ActiveAdmin::Component
      builder_method :blank_slate

      def default_class_name
        'blank_slate_container'
      end

      def build(content="")
        @contents = div(content.html_safe, class: "blank_slate")
      end

      def add_child(child)
        if @contents
          @contents << child
        else
          super
        end
      end

      def children?
        @contents.children?
      end

    end
  end
end
