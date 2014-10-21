module ActiveAdmin
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Active Admin"

      source_root File.expand_path("../templates", __FILE__)

      def generate_config_file
        template "admin.rb", "app/admin/#{file_path.tr('/', '_')}.rb"
      end

    end
  end
end
