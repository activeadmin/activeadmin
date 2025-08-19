# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def install_assets
        remove_file "app/assets/stylesheets/active_admin.scss"
        remove_file "app/assets/javascripts/active_admin.js"
        template "active_admin.css", "app/assets/stylesheets/active_admin.css"
        template "tailwind.config.js", "tailwind-active_admin.config.js"
      end
    end
  end
end
