module ActiveAdmin
  class Engine < Rails::Engine
    if Rails.version > "3.1"
      initializer "ActiveAdmin precompile hook" do |app|
        app.config.assets.precompile += ['active_admin.js', 'active_admin.css']
      end
    end
  end
end
