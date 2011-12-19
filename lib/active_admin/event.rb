module ActiveAdmin

  class EventDispatcher
    def initialize
      @events = {}
    end

    def clear_all_subscribers!
      @events = {}
    end

    def subscribe(*event_names, &block)
      event_names.each do |event|
        @events[event] ||= []
        @events[event] << block
      end
    end

    def subscribers(event)
      @events[event] || []
    end

    def dispatch(event, *args)
      subscribers(event).each do |subscriber|
        subscriber.call(*args)
      end
    end
  end

  # ActiveAdmin::Event is set to a dispatcher
  Event = EventDispatcher.new

end
