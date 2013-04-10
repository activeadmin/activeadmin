require 'active_admin/helpers/collection'
require 'active_admin/view_helpers/method_or_proc_helper'

module ActiveAdmin
  module Views

    # Renders a collection of ActiveAdmin::Scope objects as a
    # simple list with a seperator
    class Scopes < ActiveAdmin::Component
      builder_method :scopes_renderer

      include ActiveAdmin::ScopeChain
      include ::ActiveAdmin::Helpers::Collection


      def default_class_name
        "scopes table_tools_segmented_control"
      end

      def tag_name
        'ul'
      end

      def build(scopes, options = {})
        scopes.each do |scope|
          build_scope(scope, options) if call_method_or_proc_on(self, scope.display_if_block)
        end
      end

      protected

      def build_scope(scope, options)
        li :class => classes_for_scope(scope) do
          scope_name = I18n.t("active_admin.scopes.#{scope.id}", :default => scope.name)

          a :href => url_for(params.merge(:scope => scope.id, :page => 1)), :class => "table_tools_button" do
            text_node scope_name
            span :class => 'count' do
              "(#{get_scope_count(scope)})"
            end if options[:scope_count] && scope.show_count
          end
        end
      end

      def classes_for_scope(scope)
        classes = ["scope", scope.id]
        classes << "selected" if current_scope?(scope)
        classes.join(" ")
      end

      def current_scope?(scope)
        if params[:scope]
          params[:scope] == scope.id
        else
          active_admin_config.default_scope(self) == scope
        end
      end

      # Return the count for the scope passed in.
      def get_scope_count(scope)
        collection_size(scope_chain(scope, collection_before_scope))
      end
    end
  end
end
