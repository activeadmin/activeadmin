# frozen_string_literal: true
require "rails/generators/active_record"

module ActiveAdmin
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs Active Admin and generates the necessary migrations"
      argument :name, type: :string, default: "AdminUser"

      hook_for :users, default: "devise", desc: "Admin user generator to run. Skip with --skip-users"
      class_option :skip_comments, type: :boolean, default: false, desc: "Skip installation of comments"

      source_root File.expand_path("templates", __dir__)

      def copy_initializer
        @underscored_user_name = name.underscore.tr("/", "_")
        @use_authentication_method = options[:users].present?
        @skip_comments = options[:skip_comments]
        template "active_admin.rb.erb", "config/initializers/active_admin.rb"
      end

      def setup_directory
        empty_directory "app/admin"
        template "dashboard.rb", "app/admin/dashboard.rb"
        if options[:users].present?
          @user_class = name
          template "admin_users.rb.erb", "app/admin/#{name.underscore.pluralize}.rb"
        end
      end

      def setup_routes
        if options[:users] # Ensure Active Admin routes occur after Devise routes so that Devise has higher priority
          inject_into_file "config/routes.rb", "\n  ActiveAdmin.routes(self)", after: /devise_for .*, ActiveAdmin::Devise\.config/
        else
          route "ActiveAdmin.routes(self)"
        end
      end

      def create_assets
        generate "active_admin:assets"
      end

      def create_migrations
        unless options[:skip_comments]
          migration_template "migrations/create_active_admin_comments.rb.erb", "db/migrate/create_active_admin_comments.rb"
        end
      end
    end
  end
end
