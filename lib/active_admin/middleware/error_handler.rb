module ActiveAdmin
  class ErrorHandler

    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      @app.call(env)
    rescue Exception => exception
      if is_active_admin_error? && use_active_admin_error_page?
        render_exception(exception)
      else
        raise exception
      end
    end

    private

    def is_active_admin_error?
      stringified_namespaces.include?(current_namespace)
    end

    def use_active_admin_error_page?
      if ActiveAdmin.application.use_active_admin_error_page.is_a?(Proc)
        ActiveAdmin.application.use_active_admin_error_page.call
      else
        ActiveAdmin.application.use_active_admin_error_page
      end
    end

    def render_exception(exception)
      @env["active_admin.original_error"] = exception

      @env["action_dispatch.request.parameters"] =
          {controller: "#{current_namespace}/error", action: "index"}

      Object.const_get(current_namespace.titleize)
          .const_get("ErrorController")
          .action(:index)
          .call(@env)
    end

    def stringified_namespaces
      ActiveAdmin.application.namespaces.collect { |namespace| namespace.name.to_s }
    end

    def current_namespace
      @env['PATH_INFO'].split('/').second
    end

  end
end