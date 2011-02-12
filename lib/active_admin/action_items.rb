require 'active_admin/helpers/optional_display'

module ActiveAdmin
  module ActionItems
    extend ActiveSupport::Concern

    included do
      self.class_inheritable_accessor :action_items
      self.action_items = []
    end

    module ClassMethods
      def action_item(options = {}, &block)
        self.action_items << ActiveAdmin::ActionItems::ActionItem.new(options, &block)
      end

      def clear_action_items!
        self.action_items = []
      end

      def action_items_for(action)
        action_items.select{|item| item.display_on?(action) }
      end
    end

    class ActionItem
      include ActiveAdmin::OptionalDisplay

      attr_accessor :block

      def initialize(options = {}, &block)
        @options, @block = options, block
        normalize_display_options!
      end
    end
  end
end
