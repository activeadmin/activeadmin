require 'active_admin/generators/boilerplate'

module ActiveAdmin
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      desc "Registers resources with Active Admin"

      class_option :include_boilerplate, type: :boolean, default: false,
        desc: "Generate boilerplate code for your resource."

      source_root File.expand_path("../templates", __FILE__)

      def generate_config_file
        @boilerplate = ActiveAdmin::Generators::Boilerplate.new(class_name)
        template "admin.rb", "app/admin/#{file_path.tr('/', '_')}.rb"
      end

    end
  end
end
