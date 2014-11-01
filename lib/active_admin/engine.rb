module ActiveAdmin
  class Engine < ::Rails::Engine
    initializer "active_admin.precompile", group: :all do |app|
      app.config.assets.precompile += %w(active_admin.js active_admin.css active_admin/print.css)
    end
  end
end
