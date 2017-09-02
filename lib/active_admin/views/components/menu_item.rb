module ActiveAdmin
  module Views

    # Arbre component used to render ActiveAdmin::MenuItem
    class MenuItem < Component
      builder_method :menu_item

      def build(item, options = {})
        super(options.merge(id: item.id))

        add_class "current" if item.current? assigns[:current_tab]

        if url = item.url(self)
          a item.label(self), item.html_options.merge(href: url)
        else
          span item.label(self), item.html_options
        end

        if children = item.items(self).presence
          add_class "has_nested"

          ul do
            children.each do |child|
              menu_item(child)
            end
          end
        end
      end

      def tag_name
        'li'
      end
    end
  end
end
