require 'rails/generators/active_record'

module ActiveAdmin
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs Active Admin and generates the necessary migrations"
      argument :name, type: :string, default: "AdminUser"

      hook_for :users, default: "devise", desc: "Admin user generator to run. Skip with --skip-users"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        @underscored_user_name = name.underscore
        template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboard.rb', 'app/admin/dashboard.rb'
        if options[:users].present?
          @user_class = name
          template 'admin_user.rb.erb', "app/admin/#{name.underscore}.rb"
        end
      end

      def setup_routes
        if ARGV.include? "--skip-users"
          route "ActiveAdmin.routes(self)"
        else # Ensure Active Admin routes occur after Devise routes so that Devise has higher priority
          inject_into_file "config/routes.rb", "\n  ActiveAdmin.routes(self)", after: /devise_for .*, ActiveAdmin::Devise\.config/
        end
      end

      def create_assets
        js_app_file_path = 'app/assets/javascript/application.js'
        css_app_file_path = 'app/assets/stylesheets/application.css'

        if File.exist?(js_app_file_path) or File.exist?(css_app_file_path)
          js_size, match_js = match_in_file(js_app_file_path, /\/\/= require_tree \./)
          css_size, match_css = match_in_file(css_app_file_path, / \*= require_tree \./)
          if (js_size + css_size) > 0
            say(match_js.first.to_s + ' directive found into ' + js_app_file_path) if js_size > 0
            say(match_css.first.to_s + ' directive found into ' + css_app_file_path) if css_size > 0
            say('This means that you are using a Rails version with the require_tree directive')
            if ask('Deploy assets under vendor/assets? [yes]/no', :default => 'yes') == 'yes'
              generate 'active_admin:vendor'
            else
              say('Ok falling back to app/assets')
              generate 'active_admin:assets'
            end
          else
            generate 'active_admin:assets'
          end
        end
      end

      def create_migrations
        migration_template 'migrations/create_active_admin_comments.rb', 'db/migrate/create_active_admin_comments.rb'
      end

      private

      def match_in_file(file_path, regexpr)
        size = 0
        begin
          string_matched = open(file_path) { |f| f.grep(regexpr) }
          size = string_matched.size
        rescue Errno::ENOENT
          #do nothing
        end
        [size, string_matched]
      end
    end
  end
end
