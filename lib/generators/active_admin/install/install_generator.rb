require "rails/generators/active_record"

module ActiveAdmin
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs Active Admin and generates the necessary migrations"
      argument :name, type: :string, default: ""

      class_option "skip-users", type: :boolean, default: false, desc: "No authentication"
      class_option :no_interaction, type: :boolean, default: false, desc: "No User Interaction"
      class_option :skip_comments, type: :boolean, default: false, desc: "Skip installation of comments"
      class_option :use_webpacker, type: :boolean, default: false, desc: "Use Webpacker assets instead of Sprockets"

      source_root File.expand_path("templates", __dir__)

      def interactive_setup
        @use_authentication_method = true
        if options["skip-users"]
          @use_authentication_method = false
        else
          return unless @name.strip.empty?
          set_default_admin_name

          unless options[:no_interaction]
            if yes?("Do you want authentication with Devise? [y for yes]")
              @name = ask("What would you like the user model to be called? [Press Enter for default: AdminUser]")
              set_default_admin_name if @name.strip.empty?
            else
              @use_authentication_method = false
            end
          end
        end
      end

      def setup_devise
        if @use_authentication_method
          generate("active_admin:devise", @name)
        end
      end

      def copy_initializer
        @underscored_user_name = @name.underscore.gsub("/", "_")
        @skip_comments = options[:skip_comments]
        @use_webpacker = options[:use_webpacker]
        template "active_admin.rb.erb", "config/initializers/active_admin.rb"
      end

      def setup_directory
        empty_directory "app/admin"
        template "dashboard.rb", "app/admin/dashboard.rb"
        if @use_authentication_method
          @user_class = @name
          template "admin_users.rb.erb", "app/admin/#{@name.underscore.pluralize}.rb"
        end
      end

      def setup_routes
        if @use_authentication_method # Ensure Active Admin routes occur after Devise routes so that Devise has higher priority
          inject_into_file "config/routes.rb", "\n  ActiveAdmin.routes(self)", after: /devise_for .*, ActiveAdmin::Devise\.config/
        else
          route "ActiveAdmin.routes(self)"
        end
      end

      def create_assets
        if options[:use_webpacker]
          generate "active_admin:webpacker"
        else
          generate "active_admin:assets"
        end
      end

      def create_migrations
        unless options[:skip_comments]
          migration_template "migrations/create_active_admin_comments.rb.erb", "db/migrate/create_active_admin_comments.rb"
        end
      end

      private
      def set_default_admin_name
        @name = "AdminUser"
      end
    end
  end
end
