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
        counted_scopes = scopes.select { |scope| scope.show_count && options[:scope_count] }
        build_async_counts(counted_scopes)

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

      def build_async_counts(scopes)
        @async_counts ||= if async_counts?
                            scopes.index_with do |scope|
                              AsyncCount.new(scope_chain(scope, collection_before_scope))
                            end
                          else
                            {}
                          end
      end

      # Return the count for the scope passed in.
      def get_scope_count(scope)
        chained = scope_chain(scope, collection_before_scope)

        collection_size(@async_counts[scope] || chained)
      end

      def group_class(group)
        group.present? ? "scope-group-#{group}" : "scope-default-group"
      end

      class AsyncCount
        def initialize(collection)
          @collection = collection.except(:select, :order)
          @promise = @collection.async_count
        end

        def count
          value = @promise.value
          # value.value due to Rails bug https://github.com/rails/rails/issues/50776
          value.respond_to?(:value) ? value.value : value
        end

        def limit_value
          nil
        end

        delegate :except, :group_values, to: :@collection
      end
    end
  end
end
