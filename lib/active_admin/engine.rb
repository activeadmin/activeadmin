module ActiveAdmin
  class Engine < ::Rails::Engine
    initializer "ActiveAdmin precompile hook", group: :all do |app|
      app.config.assets.precompile += %w(active_admin.js active_admin.css active_admin/print.css)
    end

    initializer "ActiveAdmin info page setup" do
      ActiveAdmin.setup do |config|
        config.namespace :active_admin do |active_admin|
          active_admin.authorization_adapter = ActiveAdmin::AuthorizationAdapter
          active_admin.authentication_method = false
          active_admin.current_user_method = false
        end
      end
    end
  end
end
