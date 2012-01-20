module ActiveAdmin
  module Callbacks
    extend ActiveSupport::Concern

    protected

    # Simple callback system. Implements before and after callbacks for
    # use within the controllers.
    #
    # We didn't use the ActiveSupport callbacks becuase they do not support
    # passing in any arbitrary object into the callback method (which we
    # need to do)

    def call_callback_with(method, *args)
      case method
      when Symbol
        send(method, *args)
      when Proc
        instance_exec(*args, &method)
      else
        raise "Please register with callbacks using a symbol or a block/proc."
      end
    end

    module ClassMethods

      # Define a new callback.
      #
      # Example:
      #
      #   class MyClassWithCallbacks
      #     include ActiveAdmin::Callbacks
      #
      #     define_active_admin_callbacks :save
      #
      #     before_save do |arg1, arg2|
      #       # runs before save
      #     end
      #
      #     after_save :call_after_save
      #
      #     def save
      #       # Will run before, yield, then after
      #       run_save_callbacks :arg1, :arg2 do
      #         save!
      #       end
      #     end
      #
      #     protected
      #
      #     def call_after_save(arg1, arg2)
      #       # runs after save
      #     end
      #   end
      #     
      def define_active_admin_callbacks(*names)
        names.each do |name|
          [:before, :after].each do |type|

            # Define a method to set the callback
            class_eval(<<-EOS, __FILE__, __LINE__ + 1)
              # def self.before_create_callbacks
              def self.#{type}_#{name}_callbacks
                @#{type}_#{name}_callbacks ||= []
              end

              # def self.before_create
              def self.#{type}_#{name}(method = nil, &block)
                #{type}_#{name}_callbacks << (method || block)
              end
            EOS
          end

          # Define a method to run the callbacks
          class_eval(<<-EOS, __FILE__, __LINE__ + 1)
            def run_#{name}_callbacks(*args)
              self.class.before_#{name}_callbacks.each{|callback| call_callback_with(callback, *args)}
              value = yield if block_given?
              self.class.after_#{name}_callbacks.each{|callback| call_callback_with(callback, *args)}
              return value
            end
            EOS
         end
       end
    end
  end
end
