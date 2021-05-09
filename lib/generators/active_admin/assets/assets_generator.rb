# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      source_root File.expand_path("templates", __dir__)

      def install_assets
        template "active_admin.js", "app/assets/javascripts/active_admin.js"
        template "active_admin.scss", "app/assets/stylesheets/active_admin.scss"
      end

    end
  end
end
