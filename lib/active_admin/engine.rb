module ActiveAdmin
  class Engine < Rails::Engine
    initializer "ActiveAdmin precompile hook" do |app|
      app.config.assets.precompile += ['active_admin.js', 'active_admin.css']
    end
  end
end
