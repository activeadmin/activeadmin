# frozen_string_literal: true
require "active_admin/filters/active"

module ActiveAdmin
  module Filters
    class ActiveSidebar < ActiveAdmin::SidebarSection

      def initialize
        super "search_status", sidebar_options
      end

      def block
        -> do
          def scope_block(current_scope)
            return unless current_scope

            h4 I18n.t("active_admin.search_status.current_scope"), style: "display: inline"
            b scope_name(current_scope), class: "current_scope_name"
          end

          def filters_list(active_filters, active_scopes)
            h4 I18n.t("active_admin.search_status.current_filters")
            ul do
              if active_filters.filters.blank? && active_scopes.blank?
                li I18n.t("active_admin.search_status.no_current_filters")
              else
                active_filters.filters.each { |filter| filter_item(filter) }
                active_scopes.each { |name, value| scope_item(name, value) }
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
            filter = active_admin_config.filters[name.to_sym]
            label = filter ? filter[:label] : name.titleize

            li class: "current_filter_#{name}" do
              span "#{label} #{Ransack::Translate.predicate('eq')}"
              b value
            end
          end

          active_filters = ActiveAdmin::Filters::Active.new(active_admin_config, assigns[:search])
          active_scopes = assigns[:search].instance_variable_get("@scope_args")

          scope_block(current_scope)
          filters_list(active_filters, active_scopes)
        end
      end

      def title
        I18n.t("active_admin.search_status.headline")
      end

      protected

      def sidebar_options
        { only: :index, if: -> { active_admin_config.current_filters_enabled? && (params[:q] || params[:scope]) } }
      end

    end
  end
end
