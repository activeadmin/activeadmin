module ActiveAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installs ActiveAdmin in a rails 3 application"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end  

      def copy_initializer
        template 'active_admin.rb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        empty_directory "app/admin"
      end

      def setup_routes
        route "ActiveAdmin.routes(self)"
      end

      def copy_assets
        template 'active_admin.css',        'public/stylesheets/active_admin.css'
        template 'active_admin_vendor.js',  'public/javascripts/active_admin_vendor.js'
        template 'active_admin.js',         'public/javascripts/active_admin.js'
        directory 'images', 'public/images/active_admin'
      end
    end
  end
end
