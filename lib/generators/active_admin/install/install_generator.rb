require 'rails/generators/active_record'
require 'tempfile'

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

        manage_require_tree(js_app_file_path, css_app_file_path)
      end

      def create_migrations
        migration_template 'migrations/create_active_admin_comments.rb', 'db/migrate/create_active_admin_comments.rb'
      end

      private

      def manage_require_tree(js_app_file_path, css_app_file_path)
        if File.exist?(js_app_file_path) or File.exist?(css_app_file_path)
          js_size, match_js = match_in_file(js_app_file_path, /\/\/= require_tree \./)
          css_regexpr = / \*= require_tree \./
          css_size, match_css = match_in_file(css_app_file_path, css_regexpr)

          if (js_size + css_size) > 0
            say(match_js.first.to_s + ' directive found into ' + js_app_file_path) if js_size > 0
            say(match_css.first.to_s + ' directive found into ' + css_app_file_path) if css_size > 0
            answer = collect_user_answer
            process_answer(css_app_file_path, css_regexpr, answer)
          else
            generate 'active_admin:assets'
          end
        else
          generate 'active_admin:assets'
        end
      end

      def collect_user_answer
        say('This means that you are using a Rails version with the require_tree directive')
        say('Please choose how to proceed:')
        question = <<-EOF
1) Deploy assets under vendor/assets
2) Remove the require_tree directive from application.css
3) Remove application.css file entirely? (only appropriate for root-level installs)
        EOF
        ask(question, :limited_to => %w(1 2 3))
      end

      def process_answer(css_file_path, regex, answer)
        if answer == '1'
          generate 'active_admin:vendor'
        else
          if answer == '2'
            delete_matched_line(css_file_path, regex)
          elsif answer == '3'
            delete_file(css_file_path)
          end
          generate 'active_admin:assets'
        end
      end

      def match_in_file(file_path, regex)
        size = 0
        begin
          string_matched = File.open(file_path) { |f| f.grep(regex) }
          size = string_matched.size
        rescue Errno::ENOENT
          #do nothing
        end
        [size, string_matched]
      end

      def delete_matched_line(file_path, line_regex)
        tmp = Tempfile.new('application_without_require_tree.css')
        begin
          File.open(file_path, 'r').each do |line|
            if line =~ line_regex
              #skip matched line
            else
              tmp << line
            end
          end
          tmp.close
          FileUtils.mv(tmp.path, file_path)
          say('require_tree directive removed')
        rescue Errno::ENOENT
          tmp.close
          say('error during delete of matched line')
          #do nothing
        end
      end

      def delete_file(file_path)
        begin
          File.chmod(0777, file_path)
          File.delete(file_path)
          say('application.css removed')
        rescue Errno::EACCES
          say('error during delete operation')
          #do nothing
        end
      end
    end
  end
end
