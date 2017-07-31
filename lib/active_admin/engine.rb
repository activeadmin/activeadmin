module ActiveAdmin
  class Engine < ::Rails::Engine
    initializer "active_admin.load_app_path" do |app|
      ActiveAdmin.application.instance_exec(app) do |app|
        default_settings[:app_path] = app.root
        default_settings[:load_paths] = [File.expand_path('app/admin', app.root)]
      end
    end

    initializer "active_admin.precompile", group: :all do |app|
      app.config.assets.precompile += [
        'active_admin.css',
        'active_admin/print.css',
        'active_admin.js'
      ]
    end

    initializer 'active_admin.routes' do
      require 'active_admin/helpers/routes/url_helpers'
    end
  end
end
