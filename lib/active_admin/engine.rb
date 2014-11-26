module ActiveAdmin
  class Engine < ::Rails::Engine
    if Rails.version > "3.1"
      initializer "ActiveAdmin precompile hook", :group => :all do |app|
        ActiveAdmin.application.stylesheets.each do |path, _|
          app.config.assets.precompile << path
        end
        ActiveAdmin.application.javascripts.each do |path|
          app.config.assets.precompile << path
        end
      end
    end
  end
end
