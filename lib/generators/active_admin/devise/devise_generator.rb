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

      def set_namespace_for_path
        routes_file = File.join(destination_root, "config", "routes.rb")
        gsub_file routes_file, /devise_for :#{plural_table_name}/, "devise_for :#{plural_table_name}, ActiveAdmin::Devise.config"
      end

      def add_default_user_to_migration
        # Don't assume that we have a migration!
        devise_migrations = Dir["db/migrate/*_devise_create_#{table_name}.rb"]
        if devise_migrations.size > 0
          inject_into_file  Dir["db/migrate/*_devise_create_#{table_name}.rb"].first, 
                            "# Create a default user\n    #{class_name}.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')\n\n    ",
                            :before => "add_index :#{table_name}, :email"
        end
      end

    end
  end
end
