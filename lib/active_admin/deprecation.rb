module ActiveAdmin
  module Deprecation
    module_function

    def warn(message, callstack = caller)
      ActiveSupport::Deprecation.warn "Active Admin: #{message}", callstack
    end

  end
end
