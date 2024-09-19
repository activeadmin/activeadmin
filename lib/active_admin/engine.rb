# frozen_string_literal: true
module ActiveAdmin
  class Engine < ::Rails::Engine
    isolate_namespace ActiveAdmin

    # Set default values for app_path and load_paths before running initializers
    initializer "active_admin.load_app_path", before: :load_config_initializers do |app|
      ActiveAdmin::Application.setting :app_path, app.root
      ActiveAdmin::Application.setting :load_paths, [File.expand_path("app/admin", app.root)]
    end

    initializer "active_admin.precompile", group: :all do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w(active_admin.js active_admin.css active_admin_manifest.js)
      end
    end

    initializer "active_admin.importmap", after: "importmap" do |app|
      # Skip if importmap-rails is not installed
      next unless app.config.respond_to?(:importmap)

      ActiveAdmin.importmap.draw(Engine.root.join("config", "importmap.rb"))
      package_path = Engine.root.join("app/javascript")
      if app.config.respond_to?(:assets)
        app.config.assets.paths << package_path
        app.config.assets.paths << Engine.root.join("vendor/javascript")
      end

      if app.config.importmap.sweep_cache
        ActiveAdmin.importmap.cache_sweeper(watches: package_path)
        ActiveSupport.on_load(:action_controller_base) do
          before_action { ActiveAdmin.importmap.cache_sweeper.execute_if_updated }
        end
      end
    end

    initializer "active_admin.routes" do
      require_relative "helpers/routes/url_helpers"
    end

    initializer "active_admin.deprecator" do |app|
      app.deprecators[:activeadmin] = ActiveAdmin.deprecator if app.respond_to?(:deprecators)
    end
  end
end
