# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def install_assets
        template "active_admin.css", "app/assets/stylesheets/active_admin.css"
        template "package.json", "package.json"
        template "tailwind.config.js", "tailwind-active_admin.config.js"
      end
    end
  end
end
