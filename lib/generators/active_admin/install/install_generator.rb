module ActiveAdmin
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      desc "Installs Active Admin and generats the necessary migrations"
      argument :name, :type => :string, :default => "AdminUser"

      hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"

      include Rails::Generators::Migration

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        @underscored_user_name = name.underscore
        template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboards.rb', 'app/admin/dashboards.rb'
      end

      def setup_routes
        route "ActiveAdmin.routes(self)"
      end

      def create_assets
        generate "active_admin:assets"
      end
    end
  end
end
