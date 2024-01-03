# frozen_string_literal: true
require "active_admin/view_helpers/method_or_proc_helper"

module ActiveAdmin
  module Views
    # Renders a collection of ActiveAdmin::Scope objects as a
    # simple list with a seperator
    class Scopes < ActiveAdmin::Component
      include ActiveAdmin::ScopeChain

      def tag_name
        "div"
      end

      def build(scopes, options = {})
        super({ role: "toolbar" })
        add_class "scopes"
        scopes.group_by(&:group).each do |group, group_scopes|
          div class: "index-button-group", role: "group", data: { "group": group_name(group) } do
            group_scopes.each do |scope|
              build_scope(scope, options) if call_method_or_exec_proc(scope.display_if_block)
            end

            nil
          end
        end
      end

      protected

      def build_scope(scope, options)
        params = request.query_parameters.except :page, :scope, :commit, :format

        a href: url_for(scope: scope.id, params: params), class: classes_for_scope(scope) do
          text_node scope_name(scope)
          if options[:scope_count] && scope.show_count
            span get_scope_count(scope), class: "scopes-count"
          end
        end
      end

      def classes_for_scope(scope)
        classes = ["index-button"]
        classes << "index-button-selected" if current_scope?(scope)
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

      def group_name(group)
        group.present? ? group : "default"
      end
    end
  end
end
