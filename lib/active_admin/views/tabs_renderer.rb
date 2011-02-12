module ActiveAdmin
  module Views

    # Renders out a horizontal list of tabs.
    class TabsRenderer < Renderer

      # Pass in an ActiveAdmin::Menu and it will display the first level
      # of navigation as a horizontal list of tabs
      def to_html(menu, options = {})
        @options = default_options.merge(options)
        render_menu(menu)
      end

      protected

      def render_menu(menu)
        content_tag :ul, :id => @options[:id] do
          menu.items.collect do |item|
            render_item(item)
          end.join.html_safe
        end
      end

      def render_item(item)
        content_tag :li, :id => item.dom_id, :class => [("current" if current?(item)), ("has_nested" unless item.children.blank?)].compact.join(" ") do
          unless item.children.blank?
            link_to(item.name, item.url || "#") + render_nested_menu(item)
          else
            link_to item.name, item.url
          end
        end
      end
      
      def render_nested_menu(item)
        content_tag :ul do
          item.children.collect {|child| render_item(child)}.join.html_safe
        end
      end

      # Returns true if the menu item name is @current_tab
      def current?(menu_item)
        @current_tab.split("/").include?(menu_item.name) unless @current_tab.blank?
      end

      def default_options
        { :id => "tabs" }
      end

    end

  end
end
