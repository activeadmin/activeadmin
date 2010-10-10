module ActiveAdmin
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      desc "Creates an admin user and uses Devise for authentication"

      argument :name, :type => :string, :default => "AdminUser"

      class_option  :registerable, :type => :boolean, :default => false,
                    :desc => "Should the generated resource be registerable?"

      def install_devise
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
        gsub_file routes_file, /devise_for :#{table_name}/, "devise_for :#{table_name}, :path => '#{ActiveAdmin.default_namespace}'"
      end

    end
  end
end
