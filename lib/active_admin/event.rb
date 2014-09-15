module ActiveAdmin

  class EventDispatcher
    def subscribe(*event_names, &block)
      Deprecation.warn "`ActiveAdmin::Event.subscribe` is deprecated, use `ActiveSupport::Notifications.subscribe`"
      event_names.each do |event|
        ActiveSupport::Notifications.subscribe event,
          &wrap_block_for_active_support_notifications(block)
      end
    end

    def dispatch(event, *args)
      Deprecation.warn "`ActiveAdmin::Event.dispatch` is deprecated, use `ActiveSupport::Notifications.publish`"
      ActiveSupport::Notifications.publish event, *args
    end

    def wrap_block_for_active_support_notifications block
      proc { |event, *args| block.call *args }
    end
  end

  # ActiveAdmin::Event is set to a dispatcher
  Event = EventDispatcher.new
end
