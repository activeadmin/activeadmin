# frozen_string_literal: true
module ActiveAdmin
  class MenuItem
    include Menu::MenuNode

    attr_reader :html_options, :parent, :priority

    # Builds a new menu item
    #
    # @param [Hash] options The options for the menu
    #
    # @option options [String, Symbol, Proc] :label
    #         The label to display for this menu item.
    #         Default: Titleized Resource Name
    #
    # @option options [String] :id
    #         A custom id to reference this menu item with.
    #         Default: underscored_resource_name
    #
    # @option options [String, Symbol, Proc] :url
    #         The URL this item will link to.
    #
    # @option options [Integer] :priority
    #         The lower the priority, the earlier in the menu the item will be displayed.
    #         Default: 10
    #
    # @option options [Symbol, Proc] :if
    #         This decides whether the menu item will be displayed. Evaluated on each request.
    #
    # @option options [Hash] :html_options
    #         A hash of options to pass to `link_to` when rendering the item
    #
    # @option [ActiveAdmin::MenuItem] :parent
    #         This menu item's parent. It will be displayed nested below its parent.
    #
    # NOTE: for :label, :url, and :if
    # These options are evaluated in the view context at render time. Symbols are called
    # as methods on `self`, and Procs are exec'd within `self`.
    # Here are some examples of what you can do:
    #
    #   menu if:  :admin?
    #   menu url: :new_book_path
    #   menu url: :awesome_helper_you_defined
    #   menu label: ->{ User.some_method }
    #   menu label: ->{ I18n.t 'menus.user' }
    #
    def initialize(options = {})
      super() # MenuNode
      @label = options[:label]
      @dirty_id = options[:id] || options[:label]
      @url = options[:url] || "#"
      @priority = options[:priority] || 10
      @html_options = options[:html_options] || {}
      @should_display = options[:if] || proc { true }
      @parent = options[:parent]

      yield(self) if block_given? # Builder style syntax
    end

    def id
      @id ||= normalize_id @dirty_id
    end

    attr_reader :label
    attr_reader :url

    # Don't display if the :if option passed says so
    attr_reader :should_display
  end
end
