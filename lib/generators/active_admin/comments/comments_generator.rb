module ActiveAdmin
  module Generators
    class CommentsGenerator < Rails::Generators::Base
      desc "Generates the necessary migrations for ActiveAdmin comments"

      include Rails::Generators::Migration

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end

      def enable_comments
        inject_into_file 'config/initializers/active_admin.rb', "\n  config.allow_comments = true\n", :after => "ActiveAdmin.setup do |config|\n"
      end
    end
  end
end
