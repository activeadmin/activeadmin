# frozen_string_literal: true
module ActiveAdmin
  module BatchActions
    module ResourceExtension
      def initialize(*)
        super
        @batch_actions = {}
        add_default_batch_action
      end

      # @return [Array] The set of batch actions for this resource
      def batch_actions
        batch_actions_enabled? ? @batch_actions.values.sort : []
      end

      # @return [Boolean] If batch actions are enabled for this resource
      def batch_actions_enabled?
        # If the resource config has been set, use it. Otherwise
        # return the namespace setting
        @batch_actions_enabled.nil? ? namespace.batch_actions : @batch_actions_enabled
      end

      # Disable or Enable batch actions for this resource
      # Set to `nil` to inherit the setting from the namespace
      def batch_actions=(bool)
        @batch_actions_enabled = bool
      end

      # Add a new batch item to a resource
      # @param [String] title
      # @param [Hash] options
      # => :if is a proc that will be called to determine if the BatchAction should be displayed
      # => :sort_order is used to sort the batch actions ascending
      # => :confirm is a string to prompt the user with (or a boolean to use the default message)
      # => :form is a Hash of form fields you want the user to fill out
      #
      def add_batch_action(sym, title, options = {}, &block)
        @batch_actions[sym] = ActiveAdmin::BatchAction.new(sym, title, options, &block)
      end

      # Remove a batch action
      # @param [Symbol] sym
      # @return [ActiveAdmin::BatchAction] the batch action, if it was present
      #
      def remove_batch_action(sym)
        @batch_actions.delete(sym.to_sym)
      end

      # Clears all the existing batch actions for this resource
      def clear_batch_actions!
        @batch_actions = {}
      end

      private

      # @return [ActiveAdmin::BatchAction] The default "delete" action
      def add_default_batch_action
        destroy_options = {
          priority: 100,
          confirm: proc { I18n.t("active_admin.batch_actions.delete_confirmation", plural_model: active_admin_config.plural_resource_label.downcase) },
          if: proc { destroy_action_authorized?(active_admin_config.resource_class) }
        }

        add_batch_action :destroy, proc { I18n.t("active_admin.delete") }, destroy_options do |selected_ids|
          batch_action_collection.find(selected_ids).each do |record|
            authorize! ActiveAdmin::Auth::DESTROY, record
            destroy_resource(record)
          end

          redirect_to active_admin_config.route_collection_path(params),
                      notice: I18n.t(
                        "active_admin.batch_actions.successfully_destroyed",
                        count: selected_ids.count,
                        model: active_admin_config.resource_label.downcase,
                        plural_model: active_admin_config.plural_resource_label(count: selected_ids.count).downcase)
        end
      end

    end
  end

  class BatchAction

    include Comparable

    attr_reader :block, :title, :sym, :partial, :link_html_options

    DEFAULT_CONFIRM_MESSAGE = proc { I18n.t "active_admin.batch_actions.default_confirmation" }

    # Create a Batch Action
    #
    # Examples:
    #
    #   BatchAction.new :flag
    # => Will create an action that appears in the action list popover
    #
    #   BatchAction.new(:flag) { |selection| redirect_to collection_path, notice: "#{selection.length} users flagged" }
    # => Will create an action that uses a block to process the request (which receives one parameter of the selected objects)
    #
    #   BatchAction.new("Perform Long Operation on") { |selection| }
    # => You can create batch actions with a title instead of a Symbol
    #
    #   BatchAction.new(:flag, if: proc{ can? :flag, AdminUser }) { |selection| }
    # => You can provide an `:if` proc to choose when the batch action should be displayed
    #
    #   BatchAction.new :flag, confirm: true
    # => You can pass `true` to `:confirm` to use the default confirm message.
    #
    #   BatchAction.new(:flag, confirm: "Are you sure?") { |selection| }
    # => You can pass a custom confirmation message through `:confirm`
    #
    #   BatchAction.new(:flag, partial: "flag_form", link_html_options: { "data-modal-target": "modal-id", "data-modal-show": "modal-id" }) { |selection, inputs| }
    # => Pass a partial that contains a modal and with a data attribute that opens the modal with the form for the user to fill out.
    #
    def initialize(sym, title, options = {}, &block)
      @sym = sym
      @title = title
      @options = options
      @block = block
      @confirm = options[:confirm]
      @partial = options[:partial]
      @link_html_options = options[:link_html_options] || {}
      @block ||= proc {}
    end

    def confirm
      if @confirm == true
        DEFAULT_CONFIRM_MESSAGE
      else
        @confirm
      end
    end

    # Returns the display if block. If the block was not explicitly defined
    # a default block always returning true will be returned.
    def display_if_block
      @options[:if] || proc { true }
    end

    # Used for sorting
    def priority
      @options[:priority] || 10
    end

    # sort operator
    def <=>(other)
      self.priority <=> other.priority
    end
  end
end
