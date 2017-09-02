module ActiveAdmin
  module Views

    # Arbre component used to render ActiveAdmin::MenuItem
    class MenuItem < Component
      builder_method :menu_item
      attr_reader :label
      attr_reader :priority

      def build(item, options = {})
        super(options.merge(id: item.id))
        @label = item.label(self)
        @priority = item.priority
        child_items = item.items

        add_class "current" if item.current? assigns[:current_tab]

        if url = item.url(self)
          a item.label(self), item.html_options.merge(href: url)
        else
          span item.label(self), item.html_options
        end

        if child_items.any?
          add_class "has_nested"

          ul do
            child_items.each do |child|
              menu_item(child) if child.display?(self)
            end
            current_arbre_element.children.sort!
          end
        end
      end

      def tag_name
        'li'
      end

      # Sorts by priority first, then alphabetically by label if needed.
      def <=>(other)
        result = priority <=> other.priority
        result == 0 ? label <=> other.label : result
      end
    end
  end
end
