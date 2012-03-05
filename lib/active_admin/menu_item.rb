module ActiveAdmin

  class MenuItem

    attr_accessor :id, :label, :url, :priority, :parent, :display_if_block, :children

    # Build a new menu item
    #
    # @param [Hash] options The options for the menu
    #
    # @option options [String, Proc] :label
    #         The label to display for this menu item. It can either be a String or a 
    #         Proc. If the option is Proc, it is called each time the label is requested.
    #
    # @option options [String] :id
    #         A custom id to reference this menu item with. If empty an id is automatically 
    #         generated for you.
    #
    # @option options [String, Symbol] :url
    #         A string or symbol representing the url for this item. If it's a symbol, the
    #         view will automatically call the method for you.
    #
    # @option options [Integer] :priority
    #         MenuItems are sorted by priority then by label. The lower the priority, the 
    #         earlier in the menu the item will be displayed.
    #         Default: 10
    #
    # @option options [Proc] :if
    #         A block for the view to call to decide if this menu item should be displayed.
    #         The block should return true of false
    def initialize(options = {})
      @label    = options[:label]
      @id       = MenuItem.generate_item_id(options[:id] || label)
      @url      = options[:url]
      @priority = options[:priority] || 10
      @children = Menu::ItemCollection.new

      @display_if_block = options[:if]

      yield(self) if block_given? # Builder style syntax
    end

    def self.generate_item_id(id)
      id.to_s.downcase.gsub(" ", "_")
    end

    def label
      case @label
      when Proc
        @label.call
      else
        @label.to_s
      end
    end

    def add(*menu_items)
      menu_items.each do |menu_item|
        menu_item.parent = self
        @children << menu_item
      end
    end

    def children
      @children.sort
    end

    def parent?
      !parent.nil?
    end

    def dom_id
      id.gsub( " ", '_' ).gsub( /[^a-z0-9_]/, '' )
    end

    # Returns an array of the ancestory of this menu item
    # The first item is the immediate parent fo the item
    def ancestors
      return [] unless parent?
      [parent, parent.ancestors].flatten
    end

    # Returns the child item with the name passed in
    #    @blog_menu["Create New"] => <#MenuItem @name="Create New" >
    def [](id)
      @children.find_by_id(id)
    end

    def <=>(other)
      result = priority <=> other.priority
      result = label <=> other.label if result == 0
      result
    end

    # Returns the display if block. If the block was not explicitly defined
    # a default block always returning true will be returned.
    def display_if_block
      @display_if_block || lambda { |_| true }
    end

  end
end
