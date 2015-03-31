module ActiveAdmin
  class ErrorHandler

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      if is_active_admin_error?(env)
        render_exception(env, exception)
      else
        raise exception
      end
    end

    private

    def is_active_admin_error?(env)
      ActiveAdmin.application.default_namespace.to_s == env['PATH_INFO'].split('/').second
    end

    def render_exception(env, exception)
      wrapper = ActionDispatch::ExceptionWrapper.new(env, exception)
      env["STATUS"] = wrapper.status_code
      ActiveAdmin::ExceptionController.call(env)
    end
  end
end