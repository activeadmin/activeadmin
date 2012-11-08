module ActiveAdmin
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      class_option :bourbon, :type => :boolean, :default => true,
                   :desc => "Generate Bourbon scss files if using Rails 3.0.x"

      class_option :jquery, :type => :boolean, :default => true,
                   :desc => "Generate jQuery js files if using Rails 3.0.x"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def install_assets
        require 'rails'
        require 'active_admin'

        if ActiveAdmin.use_asset_pipeline?
          template '3.1/active_admin.js', 'app/assets/javascripts/active_admin.js'
          template '3.1/active_admin.css.scss', 'app/assets/stylesheets/active_admin.css.scss'
        else
          template '3.0/active_admin.js', 'public/javascripts/active_admin.js'
          directory '../../../../../app/assets/images/active_admin', 'public/images/active_admin'
          generate "jquery:install --ui" if options.jquery?
          install_bourbon if options.bourbon?
        end
      end

      private

      def install_bourbon
        rake "bourbon:install"
        create_file "public/stylesheets/sass/_bourbon.scss", '@import "bourbon/bourbon"'
      end

    end
  end
end
