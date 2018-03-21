module ActiveAdmin
  module Views

    # Renders an ActiveAdmin::Menu as a set of unordered list items.
    #
    # This component takes cares of deciding which items should be
    # displayed given the current context and renders them appropriately.
    #
    # The entire component is rendered within one ul element.
    class Menu < Component
      attr_reader :menu
      builder_method :menu

      # @param [ActiveAdmin::Menu] menu the Menu to render
      # @param [Hash] options the options as passed to the underlying ul element.
      #
      def build(menu, options = {})
        @menu = menu
        super(options)

        menu.items.each do |item|
          menu_item(item) if helpers.render_in_context self, item.should_display
        end
        children.sort!
      end

      def tag_name
        'ul'
      end
    end
  end
end
