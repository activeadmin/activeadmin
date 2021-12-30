# frozen_string_literal: true
require "active_admin/error"
require "active_admin/dependency"

module ActiveAdmin
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      desc "Creates an admin user and uses Devise for authentication"
      argument :name, type: :string, default: "AdminUser"

      class_option :registerable, type: :boolean, default: false,
                                  desc: "Should the generated resource be registerable?"

      RESERVED_NAMES = [:active_admin_user]

      class_option :default_user, type: :boolean, default: true,
                                  desc: "Should a default user be created inside the migration?"

      def install_devise
        begin
          Dependency.devise! Dependency::Requirements::DEVISE
        rescue DependencyError => e
          raise ActiveAdmin::GeneratorError, "#{e.message} If you don't want to use devise, run the generator with --skip-users."
        end

        require "devise"

        initializer_file =
          File.join(destination_root, "config", "initializers", "devise.rb")

        if File.exist?(initializer_file)
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

      def add_default_user_to_seed
        seeds_paths = Rails.application.paths["db/seeds.rb"]
        seeds_file = seeds_paths.existent.first
        return if seeds_file.nil? || !options[:default_user]

        create_user_code = "#{class_name}.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?"

        append_to_file seeds_file, create_user_code
      end
    end
  end
end
