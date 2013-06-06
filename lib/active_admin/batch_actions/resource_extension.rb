module ActiveAdmin

  module BatchActions
    module ResourceExtension
      def initialize(*)
        super
        @batch_actions = {}
        add_default_batch_actions
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
      # => :confirm is a string which the user will have to accept in order to process the action
      #
      def add_batch_action(sym, title, options = {}, &block)
        @batch_actions[sym] = ActiveAdmin::BatchAction.new(sym, title, options, &block)
      end

      # Remove a batch action
      # @param [Symbol] sym
      # @returns [ActiveAdmin::BatchAction] the batch action, if it was present
      #
      def remove_batch_action(sym)
        @batch_actions.delete(sym.to_sym)
      end

      # Clears all the existing batch actions for this resource
      def clear_batch_actions!
        @batch_actions = {}
      end

      # Path to the batch action itself
      def batch_action_path(params = {})
        [route_collection_path(params), "batch_action"].join("/")
      end

      private

      # @return [ActiveAdmin::BatchAction] The default "delete" action
      def add_default_batch_actions
        destroy_options = {
          :priority => 100,
          :confirm => proc { I18n.t('active_admin.batch_actions.delete_confirmation', :plural_model => active_admin_config.plural_resource_label.downcase) },
          :if => proc{ controller.action_methods.include?('destroy') && authorized?(ActiveAdmin::Auth::DESTROY, active_admin_config.resource_class) }
        }

        add_batch_action :destroy, proc { I18n.t('active_admin.delete') }, destroy_options do |selected_ids|
          active_admin_config.resource_class.find(selected_ids).each { |r| r.destroy }

          redirect_to active_admin_config.route_collection_path(params),
                      :notice => I18n.t("active_admin.batch_actions.succesfully_destroyed",
                                        :count => selected_ids.count,
                                        :model => active_admin_config.resource_label.downcase,
                                        :plural_model => active_admin_config.plural_resource_label(:count => selected_ids.count).downcase)
        end
      end

    end
  end

  class BatchAction

    include Comparable

    attr_reader :block, :title, :sym, :confirm

    # Create a Batch Action
    #
    # Examples:
    #
    #   BatchAction.new :flag
    # => Will create an action that appears in the action list popover
    #
    #   BatchAction.new( :flag ) { |selection| redirect_to collection_path, :notice => "#{selection.length} users flagged" }
    # => Will create an action that uses a block to process the request (which receives one paramater of the selected objects)
    #
    #   BatchAction.new( "Perform Long Operation on the" ) { |selection| }
    # => You can create batch actions with a title instead of a Symbol
    #
    #   BatchAction.new( :flag, :if => proc { can? :flag, AdminUser  } ) { |selection| }
    # => You can provide an optional :if proc to optionally display the batch action
    #
    def initialize(sym, title, options = {}, &block)
      @sym, @title, @options, @block, @confirm = sym, title, options, block, options[:confirm]
      @block ||= proc {}
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
