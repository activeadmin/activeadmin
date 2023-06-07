# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class PageGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def generate_config_file
        template "page.rb", "app/admin/#{file_path.tr('/', '_')}.rb"
      end

    end
  end
end
