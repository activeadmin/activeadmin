module ActiveAdmin
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Installs ActiveAdmin in a rails 3 application"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def generate_config_file
        template "admin.rb", "app/admin/#{file_path.gsub('/', '_').pluralize}.rb"
      end

    end
  end
end
