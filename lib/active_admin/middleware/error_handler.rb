module ActiveAdmin
  class ErrorHandler
    include MethodOrProcHelper

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      if is_active_admin_error?(env) && use_active_admin_error_page?
        render_exception(exception, env)
      else
        raise exception
      end
    end

    private

    def is_active_admin_error?(env)
      stringified_namespaces.include?(current_namespace(env))
    end

    def use_active_admin_error_page?
      render_in_context(ActiveAdmin.application, ActiveAdmin.application.use_active_admin_error_page)
    end


    def render_exception(exception, env)
      env["active_admin.original_exception"] = ActionDispatch::ExceptionWrapper.new(env, exception)

      env["action_dispatch.request.parameters"] =
          {controller: "#{current_namespace(env)}/error", action: "index"}

      Object.const_get(current_namespace(env).titleize)
          .const_get("ErrorController")
          .action(:index)
          .call(env)
    end

    def stringified_namespaces
      ActiveAdmin.application.namespaces.collect { |namespace| namespace.name.to_s }
    end

    def current_namespace(env)
      env['PATH_INFO'].split('/').second
    end

  end
end