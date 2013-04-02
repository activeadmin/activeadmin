module ActiveAdmin

  # Each Namespace builds up it's own menu as the global navigation
  #
  # To build a new menu:
  #
  #   menu = Menu.new do |m|
  #     m.add label: 'Dashboard', url: '/'
  #     m.add label: 'Users',     url: '/users'
  #   end
  #
  # If you're interested in configuring a menu item, take a look at the
  # options available in `ActiveAdmin::MenuItem`
  #
  class Menu

    def initialize
      super # MenuNode
      yield(self) if block_given?
    end

    module MenuNode
      def initialize
        @children = {}
      end

      def [](id)
        @children[normalize_id(id)]
      end
      def []=(id, child)
        @children[normalize_id(id)] = child
      end

      # Recursively builds any given menu items. There are two syntaxes supported,
      # as shown in the below examples. Both create an identical menu structure.
      #
      # Example 1:
      #   menu = Menu.new
      #   menu.add label: 'Dashboard' do |dash|
      #     dash.add label: 'My Child Dashboard'
      #   end
      #
      # Example 2:
      #   menu = Menu.new
      #   menu.add label:  'Dashboard'
      #   menu.add parent: 'Dashboard', label: 'My Child Dashboard'
      #
      def add(options)
        item = if parent = options.delete(:parent)
          (self[parent] || add(:label => parent)).add options
        else
          _add options.merge :parent => self
        end

        yield(item) if block_given?

        item
      end

      # Whether any children match the given item.
      def include?(item)
        @children.values.include? item
      end

      # Used in the UI to visually distinguish which menu item is selected.
      def current?(item)
        self == item || include?(item)
      end

      # Returns sorted array of menu items that should be displayed in this context.
      # Sorts by priority first, then alphabetically by label if needed.
      def items(context = nil)
        @children.values.select{ |i| i.display?(context) }.sort do |a,b|
          result = a.priority       <=> b.priority
          result = a.label(context) <=> b.label(context) if result == 0
          result
        end
      end

      attr_reader :children
      private
      attr_writer :children

      # The method that actually adds new menu items. Called by the public method.
      # If this ID is already taken, transfer the children of the existing item to the new item.
      def _add(options)
        item = ActiveAdmin::MenuItem.new(options)
        item.send :children=, self[item.id].children if self[item.id]
        self[item.id] = item
      end

      def normalize_id(id)
        case id
        when String, Symbol
          id.to_s.downcase.gsub ' ', '_'
        else
          raise TypeError, "#{id.class} isn't supported as a Menu ID"
        end
      end
    end

    include MenuNode

  end
end
