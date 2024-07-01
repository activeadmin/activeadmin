# frozen_string_literal: true

module ActiveAdmin
  # Catches active admin asset requests and serves them from the gem.
  class StaticAssetsMiddleware
    def initialize(app, *)
      @app = app
      @regexp = %r{^#{ActiveAdmin.application.static_assets_path}(.*)}
    end

    def call(env)
      if asset_path = env[Rack::PATH_INFO][@regexp, 1]
        static_path = File.join(__dir__, 'static_assets', 'assets', "#{asset_path}.gz")
        send_data(static_path)
      else
        @app.call(env)
      end
    end

    # This could be made more efficient with sendfile,
    # perhaps after checking main_app.config.action_dispatch.x_sendfile_header
    def send_data(path)
      data = File.read(path)
      headers = {
        'cache-control' => 'public, max-age=86400',
        'content-encoding' => 'gzip',
        'content-length' => data.bytesize.to_s,
        'content-type' => path['.css'] ? 'text/css' : 'text/javascript',
      }
      [200, headers, [data]]
    end
  end
end
