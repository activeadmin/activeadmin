module ActiveAdmin
  class ErrorHandler

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => e
      if ActiveAdmin.application.default_namespace.to_s == env['PATH_INFO'].split('/').second
        render_exception(env, e)
      else
        @app.call(env)
      end
    end

    private

    def render_exception(env, exception)
      wrapper = ActionDispatch::ExceptionWrapper.new(env, exception)
      env["STATUS"] = wrapper.status_code
      ActiveAdmin::ExceptionController.call(env)
    end
  end
end