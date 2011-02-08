module ActiveAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installs Active Admin and generats the necessary migrations"

      hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"

      include Rails::Generators::Migration

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end  

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M")
      end

      def copy_initializer
        template 'active_admin.rb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboards.rb', 'app/admin/dashboards.rb'
      end

      def setup_routes
        route "ActiveAdmin.routes(self)"
      end

      def copy_assets
        template 'active_admin.less',        'public/stylesheets/active_admin.less'
        template 'active_admin_vendor.js',  'public/javascripts/active_admin_vendor.js'
        template 'active_admin.js',         'public/javascripts/active_admin.js'
        directory 'images', 'public/images/active_admin'
      end

      def create_comments_migration
        migration_template 'create_admin_notes.rb', 'db/migrate/create_admin_notes.rb'
      end
    end
  end
end
