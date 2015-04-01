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
      stringified_namespaces.include?(current_namespace(env))
    end

    def render_exception(env, exception)
      env["active_admin.original_error"] = exception

      env["action_dispatch.request.parameters"] =
          {"controller" => "#{current_namespace(env)}/errors", "action" => "index"}

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