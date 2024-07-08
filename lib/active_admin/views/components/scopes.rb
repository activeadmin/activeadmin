# frozen_string_literal: true
require "active_admin/helpers/collection"
require "active_admin/view_helpers/method_or_proc_helper"

module ActiveAdmin
  module Views

    # Renders a collection of ActiveAdmin::Scope objects as a
    # simple list with a seperator
    class Scopes < ActiveAdmin::Component
      builder_method :scopes_renderer

      include ActiveAdmin::ScopeChain
      include ::ActiveAdmin::Helpers::Collection

      def default_class_name
        "scopes"
      end

      def tag_name
        "div"
      end

      def build(scopes, options = {})
        @scope_counts = scopes.index_with { |scope| query_scope_count(scope) }

        scopes.group_by(&:group).each do |group, group_scopes|
          ul class: "table_tools_segmented_control #{group_class(group)}" do
            group_scopes.each do |scope|
              build_scope(scope, options) if call_method_or_exec_proc(scope.display_if_block)
            end

            nil
          end
        end
      end

      protected

      def build_scope(scope, options)
        li class: classes_for_scope(scope) do
          params = request.query_parameters.except :page, :scope, :commit, :format

          a href: url_for(scope: scope.id, params: params), class: "table_tools_button" do
            text_node scope_name(scope)
            span class: "count" do
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

      def async_counts?
        collection_before_scope.respond_to?(:async_count)
      end

      def query_scope_count(scope)
        chained = scope_chain(scope, collection_before_scope)

        if async_counts?
          chained.async_count
        else
          collection_size(chain)
        end
      end

      # Return the count for the scope passed in.
      def get_scope_count(scope)
        if async_counts?
          scope_chain(scope, collection_before_scope).group_values.present? ? @scope_counts[scope].value.count : @scope_counts[scope].value.value
        else
          @scope_counts[scope]
        end
      end

      def group_class(group)
        group.present? ? "scope-group-#{group}" : "scope-default-group"
      end
    end
  end
end
