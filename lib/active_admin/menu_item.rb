module ActiveAdmin

  class MenuItem
    include Menu::MenuNode

    attr_accessor :id, :label, :url, :priority, :display_if_block, :html_options
    attr_reader :parent

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
    #
    # @option options [Hash] :html_options
    #         A hash of options to pass to `link_to` when rendering the item
    #
    # @param [ActiveAdmin::MenuItem] parent The parent menu item of this item
    #
    def initialize(options = {}, parent = nil)
      @label        = options[:label]
      @id           = normalize_id(options[:id] || label)
      @url          = options[:url] || "#"
      @priority     = options[:priority] || 10
      @html_options = options[:html_options] || {}
      @parent       = parent

      @display_if_block = options[:if]

      yield(self) if block_given? # Builder style syntax
    end

    def parent?
      !parent.nil?
    end

    def dom_id
      case id
      when Proc
        id
      else
        id.to_s.gsub( " ", '_' ).gsub( /[^a-z0-9_]/, '' )
      end
    end

    # Returns an array of the ancestory of this menu item
    # The first item is the immediate parent fo the item
    def ancestors
      return [] unless parent?
      [parent, parent.ancestors].flatten
    end

    def <=>(other)
      result = priority <=> other.priority
      result = label.to_s <=> other.label.to_s if result == 0
      result
    end

    # Returns the display if block. If the block was not explicitly defined
    # a default block always returning true will be returned.
    def display_if_block
      @display_if_block || lambda { |_| true }
    end

  end
end
