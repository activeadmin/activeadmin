module ActiveAdmin
  module Deprecation
    module_function

    def warn(message, callstack = caller)
      ActiveSupport::Deprecation.warn "Active Admin: #{message}", callstack
    end

    # Deprecate a method.
    #
    # @param [Module] klass the Class or Module to deprecate the method on
    # @param [Symbol] method the method to deprecate
    # @param [String] message the message to display to the end user
    #
    # Example:
    #
    #     class MyClass
    #       def my_method
    #         # ...
    #       end
    #       ActiveAdmin::Deprecation.deprecate self, :my_method,
    #         "MyClass#my_method is being removed in the next release"
    #     end
    #
    def deprecate(klass, method, message)
      klass.class_eval <<-EOC, __FILE__, __LINE__ + 1
        alias_method :deprecated_#{method}, :#{method}
        def #{method}(*args)
          ActiveAdmin::Deprecation.warn('#{message}', caller)
          send(:deprecated_#{method}, *args)
        end
      EOC
    end

  end
end
