module ActiveAdmin
  class Engine < ::Rails::Engine
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
