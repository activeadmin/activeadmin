require "active_admin/error"

module ActiveAdmin
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      desc "Creates an admin user and uses Devise for authentication"
      argument :name, type: :string, default: "AdminUser"

      class_option  :registerable, type: :boolean, default: false,
                    desc: "Should the generated resource be registerable?"

      RESERVED_NAMES = [:active_admin_user]

      class_option  :default_user, :type => :boolean, :default => true,
                    :desc => "Should a default user be created inside the migration?"

      def install_devise
        begin
          Dependency.devise! Dependency::Requirements::DEVISE
        rescue DependencyError => e
          raise ActiveAdmin::GeneratorError, "#{e.message} If you don't want to use devise, run the generator with --skip-users."
        end

        require 'devise'

        if File.exists?(File.join(destination_root, "config", "initializers", "devise.rb"))
          log :generate, "No need to install devise, already done."
        else
          log :generate, "devise:install"
          invoke "devise:install"
        end
      end

      def create_admin_user
        if RESERVED_NAMES.include?(name.underscore)
          raise ActiveAdmin::GeneratorError, "The name #{name} is reserved by Active Admin"
        end
        invoke "devise", [name]
      end

      def remove_registerable_from_model
        unless options[:registerable]
          model_file = File.join(destination_root, "app", "models", "#{file_path}.rb")
          gsub_file model_file, /\:registerable([.]*,)?/, ""
        end
      end

      def set_namespace_for_path
        routes_file = File.join(destination_root, "config", "routes.rb")
        gsub_file routes_file, /devise_for :#{plural_table_name}$/, "devise_for :#{plural_table_name}, ActiveAdmin::Devise.config"
      end

      def add_default_user_to_migration
        # Don't assume that we have a migration!
        devise_migration_file = Dir["db/migrate/*_devise_create_#{table_name}.rb"].first
        return if devise_migration_file.nil? || !options[:default_user]

        devise_migration_content = File.read(devise_migration_file)

        create_user_code = "#{class_name}.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')"

        if devise_migration_content["def change"]
          inject_into_file  devise_migration_file,
                            "def migrate(direction)\n    super\n    # Create a default user\n    #{create_user_code} if direction == :up\n  end\n\n  ",
                            before: "def change"
        elsif devise_migration_content[/def (self.)?up/]
          inject_into_file  devise_migration_file,
                            "# Create a default user\n    #{create_user_code}\n\n    ",
                            before: "add_index :#{table_name}, :email"
        else
          puts devise_migration_content
          raise "Failed to add default admin user to migration."
        end
      end
    end
  end
end
