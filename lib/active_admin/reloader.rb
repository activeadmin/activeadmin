module ActiveAdmin
  module Reloader
    # ActionDispatch::Reloader.to_prepare is deprecated in Rails 5.0 and will be removed from Rails 5.1
    #
    # Use ActiveSupport::Reloader if available for Rails 5, fall back to ActionDispatch::Reloader for earlier Rails
    def self.to_prepare(*args, &block)
      if defined? ActiveSupport::Reloader
        ActiveSupport::Reloader.to_prepare(*args, &block)
      else
        ActionDispatch::Reloader.to_prepare(*args, &block)
      end
    end

    # ActionDispatch::Reloader.to_cleanup is deprecated in Rails 5.0 and will be removed from Rails 5.1
    #
    # Use ActiveSupport::Reloader if available for Rails 5, fall back to ActionDispatch::Reloader for earlier Rails
    def self.to_complete(*args, &block)
      if defined? ActiveSupport::Reloader
        ActiveSupport::Reloader.to_complete(*args, &block)
      else
        ActionDispatch::Reloader.to_cleanup(*args, &block)
      end
    end
  end
end
