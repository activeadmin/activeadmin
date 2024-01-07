# frozen_string_literal: true
module ActiveAdmin
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../", __dir__)

      def copy_views
        directory "app/views/layouts"
        directory "app/views/active_admin", recursive: false
        directory "app/views/active_admin/devise"
        directory "app/views/active_admin/kaminari"
        copy_file "app/views/active_admin/shared/_resource_comments.html.erb"
        copy_file "app/views/active_admin/resource/_index_blank_slate.html.erb"
        copy_file "app/views/active_admin/resource/_index_empty_results.html.erb"
      end
    end
  end
end
