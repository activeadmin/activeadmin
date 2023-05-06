# frozen_string_literal: true
require "active_admin/helpers/optional_display"

module ActiveAdmin

  class Resource
    module ActionItems

      # Adds the default action items to a resource when it's initialized
      def initialize(*args)
        super
        add_default_action_items
      end

      # @return [Array] The set of action items for this resource
      def action_items
        @action_items ||= []
      end

      # Add a new action item to a resource
      #
      # @param [Symbol] name
      # @param [Hash] options valid keys include:
      #                 :only:  A single or array of controller actions to display
      #                         this action item on.
      #                 :except: A single or array of controller actions not to
      #                          display this action item on.
      #                 :priority: A single integer value. To control the display order. Default is 10.
      def add_action_item(name, options = {}, &block)
        self.action_items << ActiveAdmin::ActionItem.new(name, options, &block)
      end

      def remove_action_item(name)
        self.action_items.delete_if { |item| item.name == name }
      end

      # Returns a set of action items to display for a specific controller action
      #
      # @param [String, Symbol] action the action to retrieve action items for
      #
      # @return [Array] Array of ActionItems for the controller actions
      def action_items_for(action, render_context = nil)
        action_items.select { |item| item.display_on? action, render_context }.sort_by(&:priority)
      end

      # Clears all the existing action items for this resource
      def clear_action_items!
        @action_items = []
      end

      # Used by active_admin Base view
      def action_items?
        !!@action_items && @action_items.any?
      end

      private

      # Adds the default action items to each resource
      def add_default_action_items
        add_default_new_action_item
        add_default_edit_action_item
        add_default_show_action_item
      end

      # Adds the default New link on index
      def add_default_new_action_item
        add_action_item :new, only: :index do
          if controller.action_methods.include?("new") && authorized?(ActiveAdmin::Auth::NEW, active_admin_config.resource_class)
            localizer = ActiveAdmin::Localizers.resource(active_admin_config)
            link_to localizer.t(:new_model), new_resource_path
          end
        end
      end

      # Adds the default Edit link on show
      def add_default_edit_action_item
        add_action_item :edit, only: :show do
          if controller.action_methods.include?("edit") && authorized?(ActiveAdmin::Auth::EDIT, resource)
            localizer = ActiveAdmin::Localizers.resource(active_admin_config)
            link_to localizer.t(:edit_model), edit_resource_path(resource)
          end
        end
      end

      # Adds the default Destroy link on show
      def add_default_show_action_item
        add_action_item :destroy, only: :show do
          if controller.action_methods.include?("destroy") && authorized?(ActiveAdmin::Auth::DESTROY, resource)
            localizer = ActiveAdmin::Localizers.resource(active_admin_config)
            link_to localizer.t(:delete_model), resource_path(resource), method: :delete,
                                                                         data: { confirm: localizer.t(:delete_confirmation) }
          end
        end
      end

    end
  end

  # Model class to store the data for ActionItems
  class ActionItem
    include ActiveAdmin::OptionalDisplay

    attr_accessor :block, :name

    def initialize(name, options = {}, &block)
      @name = name
      @options = options
      @block = block
      normalize_display_options!
    end

    def html_class
      "action_item #{@options[:class]}".rstrip
    end

    def priority
      @options[:priority] || 10
    end
  end

end
