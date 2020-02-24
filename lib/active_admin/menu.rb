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
        parent_chain = Array.wrap(options.delete(:parent))

        item = if parent = parent_chain.shift
                 options[:parent] = parent_chain if parent_chain.any?
                 (self[parent] || add(label: parent)).add options
               else
                 _add options.merge parent: self
               end

        yield(item) if block_given?

        item
      end

      # Whether any children match the given item.
      def include?(item)
        @children.values.include?(item) || @children.values.any? { |child| child.include?(item) }
      end

      # Used in the UI to visually distinguish which menu item is selected.
      def current?(item)
        self == item || include?(item)
      end

      def items
        @children.values
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
        when String, Symbol, ActiveModel::Name
          id.to_s.downcase.tr ' ', '_'
        when ActiveAdmin::Resource::Name
          id.param_key
        else
          raise TypeError, "#{id.class} isn't supported as a Menu ID"
        end
      end
    end

    include MenuNode

  end
end
