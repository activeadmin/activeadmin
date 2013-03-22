module ActiveAdmin
  class Engine < Rails::Engine
    if Rails.version > "3.1"
      initializer "ActiveAdmin precompile hook", :group => :all do |app|
        app.config.assets.precompile += %w(active_admin.js active_admin.css active_admin/print.css)
      end
    end
  end
end
