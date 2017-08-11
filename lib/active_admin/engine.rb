module ActiveAdmin
  class Engine < ::Rails::Engine
    initializer "active_admin.load_app_path" do |app|
      ActiveAdmin::Application.setting :app_path, app.root
      ActiveAdmin::Application.setting :load_paths, [File.expand_path('app/admin', app.root)]
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
