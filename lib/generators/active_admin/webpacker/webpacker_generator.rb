# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class WebpackerGenerator < Rails::Generators::Base

      source_root File.expand_path("templates", __dir__)

      def install_assets
        template "active_admin.js", "app/javascript/packs/active_admin.js"
        template "active_admin.scss", "app/javascript/stylesheets/active_admin.scss"
        template "print.scss", "app/javascript/packs/active_admin/print.scss"

        copy_file "#{__dir__}/plugins/jquery.js", Rails.root.join("config/webpack/plugins/jquery.js").to_s

        insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
                         "const jquery = require('./plugins/jquery')\n",
                         after: /require\(('|")@rails\/webpacker\1\);?\n/

        insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
                         "environment.plugins.prepend('jquery', jquery)\n",
                         before: "module.exports"

        run "yarn add @activeadmin/activeadmin"
      end
    end
  end
end
