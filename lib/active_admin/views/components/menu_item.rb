module ActiveAdmin
  module Views

    # Arbre component used to render ActiveAdmin::MenuItem
    class MenuItem < Component
      builder_method :menu_item
      attr_reader :label
      attr_reader :url
      attr_reader :priority

      def build(item, options = {})
        super(options.merge(id: item.id))
        @label = item.label(self)
        @url = item.url(self)
        @priority = item.priority

        add_class "current" if item.current? assigns[:current_tab]

        if url
          a label, item.html_options.merge(href: url)
        else
          span label, item.html_options
        end

        if item.items.any?
          add_class "has_nested"
          menu(item)
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
