module ActiveAdmin

  # Each Namespace builds up it's own menu as the global navigation
  #
  # To build a new menu:
  #
  #   menu = Menu.new do |m|
  #     m.add :label => "Dashboard", :url => "/"
  #     m.add :label => "Admin", :url => "/admin"
  #   end
  #
  # If you're interested in configuring a menu item, take a look at the
  # options available in `ActiveAdmin::MenuItem`
  #
  class Menu

    def initialize
      yield(self) if block_given?
    end

    module MenuNode

      # Add a new MenuItem to the menu
      #
      # Example:
      #   menu = Menu.new
      #   menu.add :label => "Dashboard" do |dash|
      #     dash.add :label => "My Child Dashboard"
      #   end
      #
      # @param [Hash] menu_items Add as many menu items as you pass in
      def add(item_options)
        parent_label = item_options[:parent]

        if parent_label
          child_options = item_options.except(:parent)
          menu_item = add_with_parent(parent_label, child_options)
        else
          menu_item = add_without_parent(item_options)
        end

        yield(menu_item) if block_given?

        menu_item
      end

      def [](id)
        children.fetch(normalize_id(id))
      end

      def include?(item)
        items.include?(item)
      end

      # @return Sorted [Array] of [MenuItem]
      def items
        children.values.sort
      end

      private

      def add_without_parent(item_options)
        menu_item = ActiveAdmin::MenuItem.new(item_options, self)
        children[menu_item.id] = menu_item
      end

      def add_with_parent(parent, item_options)
        parent_id = normalize_id(parent)
        parent = children.fetch(parent_id){ add(:label => parent) }

        parent.add(item_options)
      end

      def children
        @children ||= {}
      end

      def normalize_id(string)
        string.to_s.downcase.gsub(" ", "_")
      end

    end

    include MenuNode

  end


end
