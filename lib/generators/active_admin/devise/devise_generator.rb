module ActiveAdmin
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      desc "Creates an admin user and uses Devise for authentication"
      argument :name, :type => :string, :default => "AdminUser"

      class_option  :registerable, :type => :boolean, :default => false,
                    :desc => "Should the generated resource be registerable?"

      def install_devise
        require 'devise'
        if File.exists?(File.join(destination_root, "config", "initializers", "devise.rb"))
          log :generate, "No need to install devise, already done."
        else
          log :generate, "devise:install"
          invoke "devise:install"
        end
      end

      def create_admin_user
        invoke "devise", [name]
      end

      def remove_registerable_from_model
        unless options[:registerable]
          model_file = File.join(destination_root, "app", "models", "#{file_path}.rb")
          gsub_file model_file, /\:registerable([.]*,)?/, ""
        end
      end

      def add_attr_accessible_if_needed
        unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
          model_file = File.join(destination_root, "app", "models", "#{file_path}.rb")
          inject_into_file model_file, "  attr_accessible :email, :password, :password_confirmation, :remember_me\n", before: /end\n*\z/
        end
      end

      def set_namespace_for_path
        routes_file = File.join(destination_root, "config", "routes.rb")
        gsub_file routes_file, /devise_for :#{plural_table_name}$/, "devise_for :#{plural_table_name}, ActiveAdmin::Devise.config"
      end

      def add_default_user_to_migration
        # Don't assume that we have a migration!
        devise_migration_file = Dir["db/migrate/*_devise_create_#{table_name}.rb"].first
        return if devise_migration_file.nil?

        devise_migration_content = File.read(devise_migration_file)

        if devise_migration_content["def change"]
          inject_into_file  devise_migration_file,
                            "def migrate(direction)\n    super\n    # Create a default user\n    #{class_name}.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if direction == :up\n  end\n\n  ",
                            :before => "def change"
        elsif devise_migration_content[/def (self.)?up/]
          inject_into_file  devise_migration_file,
                            "# Create a default user\n    #{class_name}.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')\n\n    ",
                            :before => "add_index :#{table_name}, :email"
        else
          puts devise_migration_content
          raise "Failed to add default admin user to migration."
        end
      end
    end
  end
end
