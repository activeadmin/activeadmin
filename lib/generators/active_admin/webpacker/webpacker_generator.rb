module ActiveAdmin
  module Generators
    class WebpackerGenerator < Rails::Generators::Base

      source_root File.expand_path('templates', __dir__)

      def install_assets
        template 'active_admin.js', 'app/javascript/packs/active_admin.js'
        template "active_admin.scss", "app/javascript/stylesheets/active_admin.scss"
        template 'print.scss', 'app/javascript/packs/active_admin/print.scss'
      end

    end
  end
end
