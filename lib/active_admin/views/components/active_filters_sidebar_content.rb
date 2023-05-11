# frozen_string_literal: true
require "active_admin/filters/active"

module ActiveAdmin
  module Views

    class ActiveFiltersSidebarContent < ActiveAdmin::Component
      builder_method :active_filters_sidebar_content

      def build
        active_filters = ActiveAdmin::Filters::Active.new(active_admin_config, assigns[:search])
        active_scopes = assigns[:search].instance_variable_get("@scope_args")

        scope_block(current_scope)
        filters_list(active_filters, active_scopes)
      end

      def scope_block(current_scope)
        return unless current_scope

        h4 I18n.t("active_admin.search_status.current_scope"), style: "display: inline"
        b scope_name(current_scope), class: "current_scope_name"
      end

      def filters_list(active_filters, active_scopes)
        div style: "margin-top: 10px" do
          h4 I18n.t("active_admin.search_status.current_filters"), style: "margin-bottom: 10px"
          ul do
            if active_filters.filters.blank? && active_scopes.blank?
              li I18n.t("active_admin.search_status.no_current_filters")
            else
              active_filters.filters.each { |filter| filter_item(filter) }
              active_scopes.each { |name, value| scope_item(name, value) }
            end
          end
        end
      end

      def filter_item(filter)
        li filter.html_options do
          span filter.label
          b to_sentence(filter.values.map { |v| pretty_format(v) })
        end
      end

      def scope_item(name, value)
        filter_name = name.gsub(/_eq$/, "")
        filter = active_admin_config.filters[filter_name.to_sym]
        label = filter.try(:[], :label) || filter_name.titleize

        li class: "current_filter_#{name}" do
          span "#{label} #{Ransack::Translate.predicate('eq')}"
          b value
        end
      end
    end

  end
end
