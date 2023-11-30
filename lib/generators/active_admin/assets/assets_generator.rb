# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      source_root File.expand_path("templates", __dir__)

      def install_assets
        template "active_admin.js", "app/javascript/active_admin.js"
        template "active_admin.css", "app/assets/stylesheets/active_admin.css"
        template "package.json", "package.json"
        template "tailwind.config.js", "tailwind.config.js"
        template "Procfile.dev", "Procfile.dev"
        template "builds/.keep", "app/assets/builds/.keep"
      end

    end
  end
end
